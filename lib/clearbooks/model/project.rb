#!/usr/bin/env ruby


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks Project model
  # @brief    FIXME
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/createproject/
  class Project < Base

    attr_reader :id, :description, :project_name, :status

    # @!attribute [r] description
    # Required. The description of the project.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    # @!attribute [r] project_name
    # Optional. The name of the project.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    # @!attribute [r] status
    # Optional. String identifying the project status. Use one of the following values: "open", "closed" or "deleted".
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    # @fn       def initialize data {{{
    # @brief    Constructor for Project model
    #
    # @param    [FIXME]     data      FIXME
    def initialize data
      @id           = data.savon(:id).to_i
      @description  = data.savon :description
      @project_name = data.savon :project_name
      @status       = data.savon :status
    end # }}}

    # @fn       def to_savon {{{
    # @brief    Converts given Project (self) to savon readable format
    #
    # @return   [Hash]      Returns self as Savon readable Hash
    def to_savon
      {
        project: {
          :@projectName => @project_name,
          :@status => @status,
          :@description => @description
        }
      }
    end # }}}


  end # of class Project

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
