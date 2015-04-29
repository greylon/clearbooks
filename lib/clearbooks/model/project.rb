module Clearbooks
  # @class Clearbooks Project model {{{
  # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/
  class Project < Base
    attr_reader :description, :project_name, :status

    # @!attribute [r] description
    # Required. The description of the project.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    # @!attribute [r] project_name
    # Optional. The name of the project.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    # @!attribute [r] status
    # Optional. String identifying the project status. Use one of the following values: "open", "closed" or "deleted".
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createproject/

    def initialize data
      @description = data.savon :description
      @project_name = data.savon :project_name
      @status = data.savon :status
    end

    def to_savon
      {
          project: {
            :@projectName => @project_name,
            :@status => @status,
            :description => @description
          }
      }
    end
  end # }}}
end

