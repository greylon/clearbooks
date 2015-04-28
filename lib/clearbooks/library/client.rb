require 'savon'

module Clearbooks
  # @class Clearbooks SOAP client {{{
  # @brief interacts with Clearbooks API via Savon
  # @note You should not use it directly. Use static methods in Clearbooks module instead.
  # @example
  #   Clearbooks.list_invoices
  #   Clearbooks.create_entity(Clearbooks::Entity.new(...))
  class Client
    extend Savon::Model

    client wsdl: Clearbooks.config.wsdl,
        log: Clearbooks.config.log,
        logger: Clearbooks.config.logger,
        soap_header: {'tns:authenticate' => '',
                      attributes!: {'tns:authenticate' =>
                                        {apiKey: Clearbooks.config.api_key}}}

    operations :list_invoices, :create_invoice, :create_entity

    # @fn     def list_invoices {{{
    # @brief  Query list of invoices from Clearbooks API.
    # @param  [Hash] query Hash of options to filter invoices. See the list of available options in official docs: https://www.clearbooks.co.uk/support/api/docs/soap/listinvoices/
    # @return [Array, Invoice] An array or invoices.
    # @example
    #   Clearbooks.list_invoices
    def list_invoices query = {}
      defaults = { ledger: :sales }
      query = defaults.merge(query)
      response = super message: {query: '', attributes!: {query: query}}
      response = response.to_hash
      Invoice.build response[:list_invoices_response][:create_invoices_return][:invoice]
    end # }}}

    # @fn     def create_invoice {{{
    # @brief  Creates invoice via Clearbooks API.
    # @param  [Invoice] invoice An invoice to be created. See the list of available options in official API docs: https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
    # @return [Hash] [:due, :invoice_id, :invoice_prefix, :invoice_number] according to official API docs.
    # @example
    #   Clearbooks.create_invoice Clearbooks::Invoice.new(date_created: Date.today,
    #     credit_terms: 30,
    #     entity_id: 1,
    #     type: 'purchases',
    #     items: [
    #         Clearbooks::Item.new(description: 'abcd', unit_price: 10,
    #                              quantity: 5, type: '1001001', vat: 0, vat_rate: '0.00:Out')
    #     ])
    def create_invoice invoice
      response = super message: invoice.to_savon
      response = response.to_hash
      response = response[:create_invoice_response][:create_invoice_return]
      {
          due: BigDecimal.new(response[:@due]),
          invoice_id: response[:@invoice_id].to_i,
          invoice_prefix: response[:@invoice_prefix],
          invoice_number: response[:@invoice_number]
      }
    end # }}}

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
    def create_entity entity
      response = super message: entity.to_savon
      response = response.to_hash
      { entity_id: response[:create_entity_response][:create_entity_return].to_i }
    end # }}}
  end # }}}
end
