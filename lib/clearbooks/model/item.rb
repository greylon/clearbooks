module Clearbooks
  class Item < Base
    attr_reader :description, :unit_price, :quantity, :type, :vat, :vat_rate

    def initialize(data)
      @description = data[:description]
      @unit_price = BigDecimal.new data[:@unit_price]
      @quantity = data[:@quantity].to_i
      @type = data[:@type]
      @vat = data[:@vat]
      @vat_rate = data[:@vat_rate]
    end
  end
end