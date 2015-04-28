require 'spec_helper'
require 'savon'

module Clearbooks
  describe Clearbooks do
    let(:wsdl_url) { 'https://secure.clearbooks.co.uk/api/wsdl/' }

    let(:api_key_value) { ENV['CLEARBOOKS_API_KEY'] || 'demo'}

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

    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }
    let(:message) { :any }

    describe '::list_invoices' do
      let(:response) { File.read('spec/fixtures/response/invoices.xml') }
      let(:invoices) do
        savon.expects(:list_invoices).with(message: message).returns(response)
        Clearbooks.list_invoices
      end

      it 'returns invoice list' do
        expect(invoices).to be_an Array
        expect(invoices.count).to eq 3
      end

      describe Invoice do
        let(:invoice) { invoices.last }

        it 'has items' do
          expect(invoice.items).to be_an Array
          expect(invoice.items.count).to eq 3
        end

        describe Item do
          let (:item) { invoice.items.last }
          it 'has description' do
            expect(item.description).to eq '232323'
          end
        end
      end
    end

    describe '::create_invoice' do
      let(:items) { [Item.new(description: 'abcd', unit_price: 10,
                              quantity: 5, type: '1001001', vat: 0, vat_rate: '0.00:Out')] }
      let(:invoice) { Invoice.new(date_created: Date.today,
        credit_terms: 30,
        entity_id: 1,
        type: 'purchases',
        items: items)}
      let(:xml) { File.read('spec/fixtures/response/create_invoice.xml') }
      let(:response) {
        savon.expects(:create_invoice).with(message: message).returns(xml)
        Clearbooks.create_invoice(invoice)
      }

      it 'creates a new invoice' do
        expect(response).to be_a Hash
        expect(response[:due]).to eq 50
        expect(response[:invoice_id]).to eq 3
        expect(response[:invoice_prefix]).to eq 'PUR'
        expect(response[:invoice_number]).to eq '3'
      end

    end
  end
end

