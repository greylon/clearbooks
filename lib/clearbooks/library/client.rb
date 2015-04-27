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

    operations :list_invoices

    def list_invoices(query = {})
      query = {ledger: :sales}.merge(query)
      response = super message: {query: '', attributes!: {query: query}}
      Invoice.build response.to_hash[:list_invoices_response][:create_invoices_return][:invoice]
    end
  end
end
