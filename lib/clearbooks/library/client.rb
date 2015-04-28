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

    operations :list_invoices, :create_invoice

    def list_invoices(query = {})
      query = {ledger: :sales}.merge(query)
      response = super message: {query: '', attributes!: {query: query}}
      Invoice.build response.to_hash[:list_invoices_response][:create_invoices_return][:invoice]
    end

    def create_invoice(invoice)
      super(message: invoice.to_savon).to_hash
    end
  end
end
