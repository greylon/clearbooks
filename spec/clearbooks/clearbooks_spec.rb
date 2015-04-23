require 'spec_helper'
require 'savon'

describe Clearbooks do
  let(:wsdl_url) { 'https://secure.clearbooks.co.uk/api/wsdl/' }
  
  let(:api_key_value) { "demo" }
  
  let(:client) do
    Savon::Client.new do
      wsdl                    wsdl_url
      soap_version            2
      convert_request_keys_to :none
      namespace_identifier    :soap
      env_namespace           :soapenv
      soap_header             "soap:authenticate" => "", 
                              :attributes! => { "soap:authenticate" => { apiKey: api_key_value } }
      
      namespaces              "xmlns:soapenc" => "http://schemas.xmlsoap.org/soap/encoding/", 
                              "xmlns:ns1"     => "https://secure.clearbooks.co.uk/api/soap/"
    end
  end

  describe ".connect" do
    it "authenticates the user (API key) with the service" do
      pending
    end

    it "should implement a connect method" do
      pending
    end

  end

end

