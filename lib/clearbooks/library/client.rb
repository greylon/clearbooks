#!/usr/bin/env ruby

# System include
require 'savon'


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class      Clearbooks SOAP client {{{
  # @brief      interacts with Clearbooks API via Savon
  #
  # @note       You should not use it directly. Use static methods in Clearbooks module instead.
  # @example    Clearbooks.list_invoices
  #             Clearbooks.create_entity(Clearbooks::Entity.new(...))
  #
  class Client

    extend Savon::Model

    client wsdl: Clearbooks.config.wsdl,
        log: Clearbooks.config.log,
        logger: Clearbooks.config.logger,
        log_level: Clearbooks.config.log_level,
        soap_header: {'tns:authenticate' => '',
                      attributes!: {'tns:authenticate' =>
                                        {apiKey: Clearbooks.config.api_key}}}

    operations :create_invoice,
               :list_invoices,
               :void_invoice,

               :create_entity,
               :list_entities,
               :delete_entity,
               :update_entity,

               :create_project,
               :list_projects,

               :list_account_codes,

               :create_journal,
               :delete_journal,
               :create_payment,
               :allocate_payment

    # @fn     def list_invoices {{{
    # @brief  Get list of invoices from Clearbooks API.
    # @param  [Hash] query Hash of options to filter invoices. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/listinvoices/
    # @return [Array, Invoice] An array or invoices.
    # @example
    #   Clearbooks.list_invoices
    def list_invoices query = {}
      defaults = { ledger: :sales }
      attributes = defaults.merge(query)
      entity_id = attributes.delete :entity_id
      invoice_id = attributes.delete :id
      children = {}
      children[:entityId] = {'xsd:integer' => entity_id} if entity_id
      children[:id] = {'xsd:integer' => invoice_id} if invoice_id
      response = super message: {query: children, attributes!: {query: attributes}}
      response = response.to_hash
      Invoice.build response[:list_invoices_response][:create_invoices_return].andand[:invoice]
    end # }}}

    # @fn       def create_invoice {{{
    # @brief    Creates invoice via Clearbooks API.
    #
    # @param    [Invoice]   invoice     An invoice to be created. See the list of available options in official API docs: https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
    #
    # @return   [Hash]      [:due, :invoice_id, :invoice_prefix, :invoice_number] according to official API docs.
    #
    # @example
    #   Clearbooks.create_invoice Clearbooks::Invoice.new(date_created: Date.today,
    #     credit_terms: 30,
    #     entity_id: 1,
    #     type: 'purchases',
    #     items: [
    #         Clearbooks::Item.new(description: 'abcd', unit_price: 10,
    #                              quantity: 5, type: '1001001', vat: 0, vat_rate: '0.00:Out')
    #     ])
    #
    def create_invoice invoice
      response = super message: invoice.to_savon
      response = response.to_hash
      response = response[:create_invoice_response][:create_invoice_return]
      {
          due:            BigDecimal.new(response[:@due]),
          invoice_id:     response[:@invoice_id].to_i,
          invoice_prefix: response[:@invoice_prefix],
          invoice_number: response[:@invoice_number]
      }
    end # }}}

    # @fn     def void_invoice {{{
    # @brief  Voids invoice via Clearbooks API.
    # Operation taken from WSDL schema https://secure.clearbooks.co.uk/api/wsdl/
    # @param  [String] ledger 'sales' or 'purchases'.
    # @param  [Fixnum] invoice_id Invoice id.
    # @return [Hash] [:@success, :@msg] Boolean result of the operation and a short message describing an error (if any).
    # @example
    #   Clearbooks.void_invoice 'purchases', 10
    def void_invoice ledger, invoice_id
      message = {
          invoice: {
              :@type => ledger,
              :@id => invoice_id
          }
      }
      response = super message: message
      response = response.to_hash
      response[:void_invoice_response][:void_success]
    end

    # @fn     def create_entity {{{
    # @brief  Creates entity via Clearbooks API.
    # @param  [Entity] entity An entity to be created. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/createentity/
    # @return [Hash] [:entity_id] ID of the created entity.
    # @example
    #  Clearbooks.create_entity Clearbooks::Entity.new(company_name: 'DataLogic',
    #         contact_name: 'Oleg Kukareka',
    #             address1: 'Kiev',
    #             country: 'UA',
    #             postcode: '04073',
    #             email: 'info@datalogic.co.uk',
    #             website: 'https://datalogic.co.uk',
    #             phone1: '01234 567890',
    #             supplier: {
    #             default_account_code: '1001001',
    #             default_credit_terms: 30,
    #             default_vat_rate: 0
    #         })
    #
    def create_entity entity
      response = super message: entity.to_savon
      response = response.to_hash
      { entity_id: response[:create_entity_response][:create_entity_return].to_i }
    end # }}}

    # @fn     def update_entity {{{
    # @brief  Updates entity via Clearbooks API.
    # Operation taken from WSDL schema https://secure.clearbooks.co.uk/api/wsdl/
    # @param  [Entity] entity An entity to be updated. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/createentity/
    # @return [Hash] [:entity_id] ID of the updated entity.
    # @example
    #  Clearbooks.create_entity Clearbooks::Entity.new(id: 10,
    #             company_name: 'DataLogic',
    #             contact_name: 'Oleg Kukareka',
    #             address1: 'Kiev',
    #             country: 'UA',
    #             postcode: '04073',
    #             email: 'info@datalogic.co.uk',
    #             website: 'https://datalogic.co.uk',
    #             phone1: '01234 567890',
    #             supplier: {
    #             default_account_code: '1001001',
    #             default_credit_terms: 30,
    #             default_vat_rate: 0
    #         })
    def update_entity entity
      response = super message: {entityId: entity.id}.merge(entity.to_savon)
      response = response.to_hash
      { entity_id: response[:update_entity_response][:update_entity_return].to_i }
    end # }}}

    # @fn     def list_entities {{{
    # @brief  Get list of entities from Clearbooks API.
    # @param  [Hash] query Hash of options to filter entities. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/list-entities/
    # @return [Array, Entity] An array or entities.
    # @example
    #   Clearbooks.list_entities
    def list_entities query = {}
      attributes = {query: query.except(:id)}
      response = super message: {query: {id: query[:id]}, attributes!: attributes}
      response = response.to_hash
      Entity.build response[:list_entities_response][:entities][:entity]
    end # }}}

    # @fn       def delete_entity {{{
    # @brief    Deletes entity via Clearbooks API.
    #
    # @param    [Fixnum]    entity_id     Id of the entity to be deleted. See official docs: https://www.clearbooks.co.uk/support/api/docs/soap/deleteentity/
    #
    # @return   [Boolean]   True if the request was successful, otherwise false.
    #
    # @example
    #  Clearbooks.delete_entity 10
    #
    def delete_entity entity_id
      response = super message: {entityId: entity_id}
      response = response.to_hash
      response[:delete_entity_response][:delete_entity_success]
    end # }}}

    # @fn       def create_project {{{
    # @brief    Creates project via Clearbooks API.
    #
    # @param    [Project]     project     A project to be created. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/createproject/
    #
    # @return   [Hash]        [:project_id] ID of the created project.
    #
    # @example
    #       Clearbooks.create_project Project.new(description: 'Project 1 description',
    #                   project_name: 'Project 1 name',
    #                   status: 'open')
    def create_project project
      response = super message: project.to_savon
      response = response.to_hash
      { project_id: response[:create_project_response][:create_project_return][:@project_id].to_i }
    end # }}}

    # @fn       def list_projects {{{
    # @brief    Get list of projects from Clearbooks API.
    #
    # @param    [Hash]    query     Hash of options to filter projects. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/listprojects/
    #
    # @return   [Array, Project] An array or projects.
    #
    # @example
    #   Clearbooks.list_projects
    def list_projects query = {}
      response = super message: {query: query}
      response = response.to_hash
      Project.build response[:list_projects_response][:projects][:project]
    end # }}}

    # @fn       def list_account_codes {{{
    # @brief    Get list of account codes from Clearbooks API.
    #
    # @return   [Array, AccountCode] An array or projects.
    #
    # @example
    #   Clearbooks.list_account_codes
    def list_account_codes
      response = super
      response = response.to_hash
      AccountCode.build response[:list_account_codes_response][:account_codes][:account_code]
    end # }}}

    # @fn       def create_journal {{{
    # @brief    Creates journal via Clearbooks API.
    #
    # @param    [Journal]     journal     A journal to be created. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/
    #
    # @return   [Hash] [:journal_id] ID of the created journal.
    #
    def create_journal journal
      response = super message: journal.to_savon
      response = response.to_hash
      { journal_id: response[:create_journal_response][:create_journal_return][:@journal_id].to_i }
    end # }}}

    # @fn       def delete_journal {{{
    # @brief    Deletes journal via Clearbooks API.
    #
    # @param    [Fixnum]    journal_id    Id of the journal to be deleted.
    #
    # @return   [Boolean]   True if the request was successful, otherwise false.
    #
    # @example  Clearbooks.delete_journal 10
    # @see      https://www.clearbooks.co.uk/support/api/docs/soap/deletejournal/
    def delete_journal journal_id
      response = super message: {journalId: journal_id}
      response = response.to_hash
      response[:delete_journal_response][:journal_success]
    end # }}}

    # @fn       def create_payment {{{
    # @brief    Create payment via Clearbooks API
    #
    # @param    [Payment]     payment     The payment to be created. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/createpayment/
    #
    # @return   [Hash]        [:payment_id] ID of the created payment.
    # @see      https://www.clearbooks.co.uk/support/api/docs/soap/createpayment/
    #
    def create_payment payment
      response = super message: payment.to_savon
      response = response.to_hash
      { payment_id: response[:create_payment_response][:create_payment_return][:@payment_id].to_i }
    end # }}}

    # @fn       def allocate_payment {{{
    # @brief    Allocate a payment against an invoice or set of invoices.
    #
    # @param    [Hash]      params      Params of the payment. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/allocatepayment/
    #
    # @return   [Hash]      [:success, :msg] Operation results and brief message.
    # @see      https://www.clearbooks.co.uk/support/api/docs/soap/allocatepayment/
    def allocate_payment params
      invoices = params[:invoices].map do |i|
        {
            :@id      => i[:id],
            :@amount  => i[:amount]
        }
      end

      payment = {
          :@paymentId => params[:payment_id],
          :@entityId  => params[:entity_id],
          :@type      => params[:type],
          :invoices   => { invoice: invoices }
      }

      response = super message: {payment: payment}
      response = response.to_hash
      response = response[:allocate_payment_response][:status]
      {
          success:  response[:@success].to_b,
          msg:      response[:@msg]
      }
    end # }}}

  end # of class Client

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
