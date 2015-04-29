#!/usr/bin/env ruby


# System include
require 'savon'

# Custom include
require 'spec_helper'


module Clearbooks

  describe Clearbooks do

    describe Payment do
      let(:accounting_date) { '2015-05-01 00:00:00' }
      let(:type) { 'sales' }
      let(:description) { 'Description1'}
      let(:amount) { 59.99 }
      let(:entity_id) { 1 }
      let(:payment_method) { 1 }
      let(:bank_account) { 'default' }
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

  end

end