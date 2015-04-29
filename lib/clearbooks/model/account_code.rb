#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks AccountCode model
  # @brief    Used to get list of available account codes.
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/
  class AccountCode < Base

    attr_reader :id, :account_name, :group_name, :default_vat_rate, :show_sales, :show_purchases

    # @!attribute [r] id
    # Optional. The internal id of the account code.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @!attribute [r] account_name
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @!attribute [r] group_name
    # Optional. The name of the group the account code is assigned to.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @!attribute [r] default_vat_rate
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @!attribute [r] show_sales
    # Optional. Boolean value of whether the account code shows in the sales invoice form.
    # @return [Boolean]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @!attribute [r] show_purchases
    # Optional. Boolean value of whether the account code shows in the purchase invoice form.
    # @return [Boolean]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/

    # @fn       def initialize data {{{
    # @brief    Constructor for AccountCode model
    #
    # @param    [Hash]     data      Account code attributes. See https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/
    def initialize data
      @id               = data.savon(:id).to_i
      @account_name     = data.savon :account_name
      @group_name       = data.savon :group_name

      @default_vat_rate = data.savon :default_vat_rate

      @show_sales       = data.savon(:show_sales).to_b
      @show_purchases   = data.savon(:show_purchases).to_b
    end # }}}

  end # of class AccountCode

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
