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

    let(:accounting_date) { '2015-05-01 00:00:00' }
    let(:type) { 'sales' }
    let(:description) { 'Description1'}
    let(:amount) { 59.99 }
    let(:entity_id) { 1 }
    let(:payment_method) { 1 }
    let(:bank_account) { '7502001' }
    let(:invoices) do
      [ {id: 1, amount: '9.99'}, {id:9, amount: '19.99'} ]
    end

    let(:payment) { Payment.new(accounting_date: accounting_date,
                                type: type,
                                description: description,
                                amount: amount.to_s,
                                entity_id: entity_id,
                                payment_method: payment_method,
                                bank_account: bank_account,
                                invoices: invoices) }

    describe Payment do

      describe :initialize do
        it 'initializes a new payment' do
          expect(payment.accounting_date).to eq Date.parse(accounting_date)
          expect(payment.type).to eq type
          expect(payment.description).to eq description
          expect(payment.amount).to eq amount
          expect(payment.entity_id).to eq entity_id
          expect(payment.payment_method).to eq payment_method
          expect(payment.bank_account).to eq bank_account
          expect(payment.invoices.length).to eq invoices.length

          payment.invoices.each_with_index do |inv, i|
            expect(inv[:id]).to eq invoices[i][:id]
            expect(inv[:amount]).to eq invoices[i][:amount]
          end
        end
      end
    end

    describe '.create_payment' do
      let(:xml) { File.read('spec/fixtures/response/create_payment.xml') }

      let(:response) do
        savon.expects(:create_payment).with(message: message).returns(xml)
        Clearbooks.create_payment(payment)
      end

      it 'creates new payment' do
        expect(response).to be_a Hash
        expect(response[:payment_id]).to be_a Fixnum
        expect(response[:payment_id]).to be > 0
      end
    end

    describe '.allocate_payment' do
      let(:xml) { File.read('spec/fixtures/response/allocate_payment.xml') }

      let(:params) do
        {
            payment_id:   1,
            entity_id:    1,
            type:         'sales',
            invoices:     [
                {id: 1, amount: 9.99},
                {id: 2, amount: 19.99}
            ]
        }
      end

      let(:response) do
        savon.expects(:allocate_payment).with(message: message).returns(xml)
        Clearbooks.allocate_payment(params)
      end

      it 'allocates a payment against an invoice or set of invoices' do
        expect(response).to be_a Hash
        expect(response[:success]).to be true
        expect(response[:msg]).to eq 'The payment has been allocated'
      end
    end
  end
end