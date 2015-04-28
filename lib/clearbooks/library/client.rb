require 'savon'

module Clearbooks
  class Client
    extend Savon::Model

    client wsdl: Clearbooks.config.wsdl,
        log: Clearbooks.config.log,
        logger: Clearbooks.config.logger,
        soap_header: {'tns:authenticate' => '',
                      attributes!: {'tns:authenticate' =>
                                        {apiKey: Clearbooks.config.api_key}}}

    operations :list_invoices, :create_invoice, :create_entity

    def list_invoices query = {}
      defaults = { ledger: :sales }
      query = defaults.merge(query)
      response = super message: {query: '', attributes!: {query: query}}
      response = response.to_hash
      Invoice.build response[:list_invoices_response][:create_invoices_return][:invoice]
    end

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
    end

    def create_entity entity
      response = super message: entity.to_savon
      response = response.to_hash
      Hash.new entity_id: response[:create_entity_response][:create_entity_return].to_i
    end
  end
end
