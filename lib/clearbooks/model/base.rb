module Clearbooks
  class Base
    class << self
      def build(data)
        unless data.is_a? Array
          [new(data)]
        else
          return data.map{|d| new(d)}
        end
      end
    end
  end
end

