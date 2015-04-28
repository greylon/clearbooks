module Clearbooks
  # @class Clearbooks Invoice model {{{
  # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
  class Invoice < Base
    attr_reader :date_created, :date_due, :credit_terms, :description, :entity_id, :reference, :project, :status, :invoice_prefix,
                :invoice_number, :external_id, :statement_page, :date_modified, :items, :type, :bank_payment_id

    # @!attribute [r] date_created
    # Required. The tax point of the invoice.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_due
    # Required. The date the invoice is due.
    # Use either this field or creditTerms.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_accrual
    # Optional. The invoice accrual date.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] credit_terms
    # Required. The number of days after the tax point that the invoice is due.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] description
    # Optional.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] entity_id
    # Required. The customer or supplier id.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] reference
    # Optional. A reference string for the invoice.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] project
    # Optional. The id of the project to assign the invoice to.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] type
    # Optional. A string identifying the type of the invoice.
    # Value one of: purchases, sales, cn-sales, cn-purchases.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] bank_payment_id
    # Optional. The bank account code.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    def initialize data
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
      @bank_payment_id = data.savon(:bank_payment_id).to_i

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
              :@reference => @reference,
              :@project => @project,
              :@status => @status,
              :@invoice_prefix => @invoice_prefix,
              :@invoice_number => @invoice_number,
              :@external_id => @external_id,
              :@statement_page => @statement_page,
              :@date_modified => @date_modified,
              :@bank_payment_id => @bank_payment_id,
              description: @description,
              items: items.map(&:to_savon)
          }
      }
    end
  end # }}}
end

