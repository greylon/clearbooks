require 'spec_helper'
require 'savon'

module Clearbooks

  describe Clearbooks do

    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }

    let(:message) { :any }

    let(:description) { 'Journal1' }
    let(:accounting_date) { '2015-05-01 00:00:00' }
    let(:entity) { 100 }
    let(:project) { 200 }
    let(:accounts) { ['4001001', '4001002'] }
    let(:amounts) { [100.50, 200.50] }
    let(:ledgers) do
      [accounts, amounts].transpose.map do |data|
        Ledger.new(account: data[0], amount: data[1].to_s)
      end
    end

    let(:journal) { Journal.new(description: description,
                                accounting_date: accounting_date,
                                entity: entity, project: project,
                                ledgers: ledgers) }

    describe Journal do
      describe :initialize do
        it 'initializes new journal' do
          expect(journal.description).to eq description
          expect(journal.accounting_date).to eq Date.parse accounting_date
          expect(journal.entity).to eq entity
          expect(journal.project).to eq project
          expect(journal.ledgers.length).to eq ledgers.length
          journal.ledgers.each_with_index do |ledger, i|
            expect(ledger.account).to eq accounts[i]
            expect(ledger.amount).to eq amounts[i]
          end
        end
      end
    end

    describe '::create_journal' do
      let(:xml) { File.read('spec/fixtures/response/create_journal.xml') }

      let(:response) do
        savon.expects(:create_journal).with(message: message).returns(xml)
        Clearbooks.create_journal(journal)
      end

      it 'creates new journal' do
        expect(response).to be_a Hash
        expect(response[:journal_id]).to be_a Fixnum
        expect(response[:journal_id]).to be > 0
      end

    end
  end


end
