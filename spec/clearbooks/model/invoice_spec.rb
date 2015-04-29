#!/usr/bin/env ruby


# System include
require 'savon'

# Custom include
require 'spec_helper'


module Clearbooks

  describe Clearbooks do

    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }

    let(:message) { :any }

    describe '::list_invoices' do
      let(:response) { File.read('spec/fixtures/response/list_invoices.xml') }
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
  end
end


