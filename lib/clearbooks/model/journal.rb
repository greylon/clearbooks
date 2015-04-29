#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks Journal model
  # @brief    FIXME
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/listaccountcodes/
  class Journal < Base

    attr_reader :description, :accounting_date, :entity, :project, :ledgers

    # @!attribute [r] description
    # Required. The description of the journal.
    # return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/

    # @!attribute [r] accounting_date
    # Optional. The accounting date of the journal.
    # return [Date]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/

    # @!attribute [r] entity
    # Optional. The ID of an entity attached to the journal.
    # return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/

    # @!attribute [r] project
    # Optional. The ID of a project attached to the journal.
    # return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/

    # @!attribute [r] ledgers
    # Optional. An array of transactions added to the journal. Two items required.
    # return [Array, Ledger]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createjournal/


    # @fn       def initialize data {{{
    # @brief    Constructor for Journal model
    #
    # @param    [FIXME]     data      FIXME
    def initialize data
      @description = data.savon :description
      @accounting_date = data.savon :accounting_date
      @entity = data.savon :entity
      @project = data.savon :project
      @ledgers = Ledger.build data.savon :ledgers
    end # }}}

  end # of class Journal

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
