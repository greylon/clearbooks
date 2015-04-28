require 'bigdecimal'

module Clearbooks
  class Item < Base
    attr_reader :description, :unit_price, :quantity, :type, :vat, :vat_rate

    def initialize(data)
      @description = data.savon(:description)
      @unit_price = BigDecimal.new data.savon(:unit_price)
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
  end
end

