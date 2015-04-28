module Clearbooks
  class Base
    class << self

      def build data
        unless data.is_a? Array
          [create(data)]
        else
          return data.map{|d| create(d)}
        end
      end

      def create data
        if data.is_a? Hash
          new data
        else
          data
        end
      end
    end

    protected

    def parse_date date
      if date.nil? || date.is_a?(Date)
        date
      else
        DateTime.strptime date, '%Y-%m-%d %H:%M:%S'
      end
    end
  end
end

