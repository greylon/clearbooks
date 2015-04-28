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

        it 'is an Invoice' do
          expect(invoice).to be_an Invoice
        end

        it 'has proper attribute values' do
          expect(invoice.entity_id).to eq 1
          expect(invoice.invoice_id).to eq 3
          expect(invoice.invoice_prefix).to eq 'INV'
          expect(invoice.invoice_number).to eq '3'
          expect(invoice.reference).to eq 'ref1'
          expect(invoice.date_created).to eq Date.parse '2015-04-27 00:00:00'
          expect(invoice.date_due).to eq Date.parse '2015-05-27 00:00:00'
          expect(invoice.date_accrual).to eq Date.parse '2015-04-27 00:00:00'
          expect(invoice.credit_terms).to eq 30
          expect(invoice.project).to eq 7
          expect(invoice.status).to eq 'approved'
          expect(invoice.statement_page).to eq 'https://secure.clearbooks.co.uk/accounting/sales/invoice_html/?source=statement'
          expect(invoice.type).to eq 'S'
        end

        it 'has items' do
          expect(invoice.items).to be_an Array
          expect(invoice.items.count).to eq 3
        end

        describe Item do
          let (:item) { invoice.items.last }

          it 'is an Item' do
            expect(item).to be_an Item
          end

          it 'has proper description' do
            expect(item.description).to eq '232323'
          end

          it 'has proper attribute values' do
            expect(item.unit_price).to eq 5
            expect(item.vat).to eq '2'
            expect(item.quantity).to eq 1
            expect(item.type).to eq '1001001'
            expect(item.vat_rate).to eq '0.00:Out'
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
      let(:response) do
        savon.expects(:create_invoice).with(message: message).returns(xml)
        Clearbooks.create_invoice(invoice)
      end

      it 'creates a new invoice' do
        expect(response).to be_a Hash
        expect(response[:due]).to eq 50
        expect(response[:invoice_id]).to eq 3
        expect(response[:invoice_prefix]).to eq 'PUR'
        expect(response[:invoice_number]).to eq '3'
      end
    end

    describe '::create_entity' do

      let(:entity) do
        Entity.new(company_name: 'DataLogic',
                    contact_name: 'Oleg Kukareka',
                    address1: 'Kiev',
                    country: 'UA',
                    postcode: '04073',
                    email: 'info@datalogic.co.uk',
                    website: 'https://datalogic.co.uk',
                    phone1: '01234 567890',
                    supplier: {
                        default_account_code: '1001001',
                        default_credit_terms: 30,
                        default_vat_rate: 0
                    })
      end

      let(:xml) { File.read('spec/fixtures/response/create_entity.xml') }

      let(:response) do
        savon.expects(:create_entity).with(message: message).returns(xml)
        Clearbooks.create_entity(entity)
      end

      it 'creates a new entity' do
        expect(response).to be_a Hash
        expect(response[:entity_id]).to be_a Fixnum
        expect(response[:entity_id]).to be > 0
      end
    end

    describe '::list_entities', :focus => true do
      let(:xml) { File.read('spec/fixtures/response/entities.xml') }

      let(:entities) do
        savon.expects(:list_entities).with(message: message).returns(xml)
        Clearbooks.list_entities
      end

      it 'returns list of entnties' do
        expect(entities).to be_an Array
        expect(entities.length).to eq 4
      end

      describe Entity do
        let(:entity) {entities.last}

        it 'is an Entity' do
          expect(entity).to be_an Entity
        end

        it 'has proper attribute values' do
          expect(entity.id).to eq 7
          expect(entity.company_name).to eq 'DataLogic'
          expect(entity.contact_name).to eq 'Oleg Kukareka'
          expect(entity.address1).to eq 'Street 1'
          expect(entity.town).to eq 'Kiev'
          expect(entity.county).to eq 'Ukraine'
          expect(entity.postcode).to eq '04073'
          expect(entity.email).to eq 'info@datalogic.co.uk'
          expect(entity.phone1).to eq '01234 567890'
          expect(entity.building).to eq 'Building2'
          expect(entity.address2).to eq 'Street2'
          expect(entity.phone2).to eq '1234 567890'
          expect(entity.fax).to eq '2345 67890'
          expect(entity.website).to eq 'https://datalogic.co.uk'
          expect(entity.external_id).to eq 3
          expect(entity.statement_url).to eq 'https://secure.clearbooks.co.uk/s/58055:YGD2d9_WFz6GvKUv4V4anw'
          expect(entity.supplier[:default_account_code]).to eq '30'
          expect(entity.supplier[:default_vat_rate]).to eq '10'
          expect(entity.supplier[:default_credit_terms]).to eq 30
          expect(entity.customer).to be_nil
        end
      end
    end
  end
end

