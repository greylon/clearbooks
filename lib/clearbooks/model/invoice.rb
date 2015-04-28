module Clearbooks
  class Invoice < Base
    attr_reader :id, :date_created, :date_due, :credit_terms, :description, :entity_id, :reference, :project, :status, :invoice_prefix,
                :invoice_number, :external_id, :statement_page, :date_modified, :items, :type

    def initialize data
      @id = data.savon(:invoice_id).to_i
      @date_created = parse_date data.savon(:date_created)
      @date_due = parse_date data.savon(:date_due)
      @credit_terms = data.savon(:credit_terms).to_i
      @description = data.savon :description
      @entity_id = data.savon(:entity_id).to_i
      @reference = data.savon :reference
      @project = data.savon(:project).to_i
      @status = data.savon :status
      @invoice_prefix = data.savon :invoice_prefix
      @invoice_number = data.savon :invoice_number
      @external_id = data.savon(:external_id).to_i
      @statement_page = data.savon :statement_page
      @date_modified = parse_date data.savon(:date_modified)
      @type = data.savon(:type)

      @items = Item.build( data[:items].is_a?(Array) ? data[:items] : data[:items][:item])
    end

    def to_savon
      {
          invoice: {
              :@dateCreated => @date_created,
              :@entityId => @entity_id,
              :@type => @type,
              :@dateDue => @date_due,
              :@creditTerms => @credit_terms,
              description: @description,
              items: items.map(&:to_savon)
          }
      }
    end
  end
end

