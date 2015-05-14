#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks Invoice model
  # @brief    Used to list existing invoices or create new.
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
  class Invoice < Base

    attr_reader :invoice_id, :date_created, :date_due, :date_accrual, :credit_terms, :description, 
                :entity_id, :reference, :project, :status, :invoice_prefix,
                :invoice_number, :external_id, :statement_page, :date_modified, :items, :type, :bank_payment_id,
                :gross, :net, :vat, :paid, :balance, :external_id # FIXME add docs for new attributes

    alias :id :invoice_id

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


    # @fn       def initialize data {{{
    # @brief    Constructor for Invoice model
    #
    # @param    [Hash]     data      Invoice attributes. For the list of available options see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
    def initialize data
      @invoice_id       = Integer data.savon(:invoice_id) rescue nil

      @date_created     = parse_date data.savon :date_created
      @date_due         = parse_date data.savon :date_due

      @credit_terms     = Integer data.savon(:credit_terms) rescue nil
      @description      = data.savon :description

      @entity_id        = Integer data.savon(:entity_id) rescue nil
      @reference        = data.savon :reference
      @project          = Integer data.savon(:project) rescue nil
      @status           = data.savon :status

      @invoice_prefix   = data.savon :invoice_prefix
      @invoice_number   = data.savon :invoice_number
      @external_id      = data.savon :external_id
      @statement_page   = CGI.unescapeHTML data.savon :statement_page rescue nil

      @date_modified    = parse_date data.savon :date_modified
      @date_accrual     = parse_date data.savon :date_accrual

      @type             = data.savon :type
      @bank_payment_id  = Integer data.savon(:bank_payment_id) rescue nil

      @gross            = BigDecimal data.savon(:gross) rescue nil
      @net              = BigDecimal data.savon(:net) rescue nil
      @vat              = BigDecimal data.savon(:vat) rescue nil
      @paid             = BigDecimal data.savon(:paid) rescue nil
      @balance          = BigDecimal data.savon(:balance) rescue nil
      @external_id      = data.savon(:external_id)

      @items = Item.build( data[:items].is_a?(Array) ? data[:items] : data[:items][:item] )
    end # }}}

    # @fn       def to_savon {{{
    # @brief    Converts given Invoice (self) to savon readable format
    #
    # @return   [Hash]      Returns self as Savon readable Hash
    def to_savon
      {
        invoice: {
          :@dateCreated => @date_created,
          :@entityId    => @entity_id,
          :@type        => @type,
          :@dateDue     => @date_due,
          :@dateAccural => @date_accural,
          :@creditTerms => @credit_terms,
          :@reference   => @reference,
          :@project     => @project,
          :@external_id => @external_id,

          description:  @description,
          items:        { item: items.map(&:to_savon) }
        }.compact
      }
    end # }}}


  end # of class Invoice

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
