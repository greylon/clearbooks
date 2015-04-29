module Clearbooks
  # @class Clearbooks Invoice model {{{
  # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
  class Invoice < Base
    attr_reader :invoice_id, :date_created, :date_due, :date_accrual, :credit_terms, :description, :entity_id, :reference, :project, :status, :invoice_prefix,
                :invoice_number, :external_id, :statement_page, :date_modified, :items, :type, :bank_payment_id

    # @!attribute [r] invoice_id
    # @return [Fixnum] Invoice Id.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_created
    # Required. The tax point of the invoice.
    # @return [DateTime]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_due
    # Required. The date the invoice is due.
    # Use either this field or creditTerms.
    # @return [DateTime]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_accrual
    # Optional. The invoice accrual date.
    # @return [DateTime]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] credit_terms
    # Required. The number of days after the tax point that the invoice is due.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] description
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] entity_id
    # Required. The customer or supplier id.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] reference
    # Optional. A reference string for the invoice.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] project
    # Optional. The id of the project to assign the invoice to.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] type
    # Optional. A string identifying the type of the invoice.
    # Value one of: purchases, sales, cn-sales, cn-purchases.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] bank_payment_id
    # Optional. The bank account code.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] date_modified
    # @return [DateTime] Date this invoice was last modified.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] external_id
    # @return [Fixnum] Id used to link imported invoices.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] invoice_number
    # @return [String] Invoice number.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] items
    # Required.
    # @return [Item] A list of item elements identifying the line items.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] statement_page
    # @return [String] A link to a printable invoice page with a link to download as a PDF (top right corner).
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] status
    # @return [String] Invoice status: paid, unpaid.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] invoice_prefix
    # @return [String] Invoice prefix.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/


    def initialize data
      @invoice_id = data.savon(:invoice_id).to_i
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
      @date_accrual = parse_date data.savon(:date_accrual)
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
              :@dateAccural => @date_accural,
              :@creditTerms => @credit_terms,
              :@reference => @reference,
              :@project => @project,
              description: @description,
              items: items.map(&:to_savon)
          }
      }
    end
  end # }}}
end

