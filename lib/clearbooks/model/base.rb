module Clearbooks
  # @class Base class for Clearbooks API models {{{
  # @brief Implements common operations related to Savon and SOAP
  class Base
    class << self

      # @fn def build {{{
      # @brief Builds an array of items from a hash returned by Savon.
      #
      # @param data  An array of hashes representing collection or a hash representing a single item.
      #
      # @return [Array] an array of items that represent collection from hash returned by Savon.
      # @note Still returns an array when called with a hash representing a single item.
      def build data
        unless data.is_a? Array
          [create(data)]
        else
          return data.map{|d| create(d)}
        end
      end  # }}}

      # @fn def create {{{
      # @brief Creates an item from a hash returned by Savon.
      #
      # @param [Hash] data  A hash representing a single object returned by Savon.
      #
      # @return An item instantiated from a hash returned by Savon.
      def create data
        if data.is_a? Hash
          new data
        else
          data
        end
      end # }}}
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

