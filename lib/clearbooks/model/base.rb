#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic handling of Clear Books SOAP API
module Clearbooks

  # @class    Base class for Clearbooks API models {{{
  # @brief    Implements common operations related to Savon and SOAP
  class Base

    class << self

      # @fn       def build {{{
      # @brief    Builds an array of items from a hash returned by Savon
      #
      # @param    [Array]   data    An array of hashes representing collection or a hash representing a single item
      #
      # @return   [Array]   List of items that represent collection from hash returned by Savon
      #
      # @note     Still returns an array when called with a hash representing a single item.
      def build data
        unless data.is_a? Array
          [ create(data) ]
        else
          return data.map { |d| create(d) }
        end
      end  # }}}

      # @fn       def create {{{
      # @brief    Creates an item from a hash returned by Savon
      #
      # @param    [Hash]    data    Hash representing a single object returned by Savon
      #
      # @return   [Object]  An item instantiated from a hash returned by Savon
      def create data
        if data.is_a? Hash
          new data
        else
          data
        end
      end # }}}

    end # of class << self


    protected

    # @fn       def parse_date date {{{
    # @brief    Parses a given date in expected form from upstream API
    #
    # @param    [String]      date        Date string to parse
    #
    # @return   [Date]        Returns Date or DateTime from string parsing result
    def parse_date date
      if date.nil? || date.is_a?(Date)
        date
      else
        DateTime.strptime date, '%Y-%m-%d %H:%M:%S'
      end
    end # }}}

  end # of class Base
end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
