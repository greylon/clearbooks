require 'spec_helper'
require 'savon'

module Clearbooks

  describe Journal do
    let(:description) { 'Journal1' }
    let(:accounting_date) { '2015-04-25 00:00:00' }
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

    describe :initialize do
      it 'creates new journal' do
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

end
