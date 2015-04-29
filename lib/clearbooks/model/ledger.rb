#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks Ledger model
  # @brief    FIXME
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/
  class Ledger < Base

    attr_reader :account, :amount

    # @fn       def initialize data {{{
    # @brief    Constructor for Ledger model
    #
    # @param    [FIXME]     data      FIXME
    def initialize data
      @account = data.savon :description
      @amount = data.savon :amount
    end # }}}

    def to_savon
      {
          ledger: {
              :@account => @account,
              :@amount => @amount
          }.compact
      }
    end

  end # of class Ledger

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
