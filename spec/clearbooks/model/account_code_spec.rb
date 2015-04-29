require 'spec_helper'
require 'savon'

module Clearbooks
  describe Clearbooks do

    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }

    let(:message) { :any }

    describe '::list_account_codes' do
      let(:xml) { File.read('spec/fixtures/response/list_account_codes.xml') }

      let(:account_codes) do
        savon.expects(:list_account_codes).with(message: message).returns(xml)
        Clearbooks.list_account_codes
      end

      it 'returns list of account_codes' do
        expect(account_codes).to be_an Array
        expect(account_codes.length).to eq 77
      end

      describe AccountCode do
        let(:account_code) {account_codes.last}

        it 'has proper attribute values' do
          expect(account_code.id).to eq 6501001
          expect(account_code.account_name).to eq 'Corporation tax'
          expect(account_code.group_name).to eq 'Tax expense'
          expect(account_code.default_vat_rate).to eq '0.00:Out'
          expect(account_code.show_sales).to eq false
          expect(account_code.show_purchases).to eq true
        end
      end
    end
  end
end
