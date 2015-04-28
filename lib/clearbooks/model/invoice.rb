module Clearbooks
  class Invoice < Base
    attr_reader :id, :date_created, :date_due, :credit_terms, :description, :entity_id, :reference, :project, :status, :invoice_prefix,
                :invoice_number, :external_id, :statement_page, :date_modified, :items

    def initialize(data)
      @id = data[:@invoice_id].to_i
      @date_created = Date.parse data[:@date_created]
      @date_due = Date.parse data[:@date_due]
      @credit_terms = data[:@credit_terms].to_i
      @description = data[:description]
      @entity_id = data[:@entity_id].to_i
      @reference = data[:@reference]
      @project = data[:@project].to_i
      @status = data[:@status]
      @invoice_prefix = data[:@invoice_prefix]
      @invoice_number = data[:@invoice_number]
      @external_id = data[:@external_id].to_i
      @statement_page = data[:@statement_page]
      @date_modified = Date.parse(data[:@date_modified]) rescue nil

      @items = Item.build data[:items][:item]
    end
  end
end

