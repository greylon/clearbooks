require 'bigdecimal'

module Clearbooks
  # @class Clearbooks Item model {{{
  # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/
  class Item < Base
    attr_reader :description, :unit_price, :quantity, :type, :vat, :vat_rate

    # @!attribute [r] description
    # Required.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] unit_price
    # Required.
    # @return [BigDecimal] The unit price of an item in pounds.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] quantity
    # Required.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] type
    # Required. The account code identifying the revenue stream.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] vat
    # Required. The total amount of VAT in pounds. Use either this field or vat_rate.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    # @!attribute [r] vat_rate
    # Required. The percentage VAT as a decimal number. Use either this field or vat.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createinvoice/

    def initialize data
      @description = data.savon :description
      @unit_price = BigDecimal.new data.savon :unit_price
      @quantity = data.savon(:quantity).to_i
      @type = data.savon :type
      @vat = data.savon :vat
      @vat_rate = data.savon :vat_rate
    end

    def to_savon
      {
          item: {
            :@unitPrice => @unit_price.to_f,
            :@quantity => @quantity,
            :@type => @type,
            :@vat => @vat,
            :@vat_rate => @vat_rate,
            description: @description
          }
      }
    end
  end # }}}
end

