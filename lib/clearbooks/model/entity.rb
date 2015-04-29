#!/usr/bin/env ruby

# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Clearbooks Entity model
  # @brief    FIXME
  #
  # @see      https://www.clearbooks.co.uk/support/api/docs/soap/createentity/
  class Entity < Base

    attr_reader :id,
                :company_name,  # string required
                :contact_name,  # string optional
                :building,      # string optional
                :address1,      # string optional
                :address2,      # string optional
                :town,          # string optional
                :county,        # string optional
                :country,       # string optional
                # country codes http://www.iso.org/iso/support/country_codes/iso_3166_code_lists/iso-3166-1_decoding_table.htm
                :postcode,      # string optional
                :email,         # string optional
                :phone1,        # string optional
                :phone2,        # string optional
                :fax,           # string optional
                :website,       # string optional
                :external_id,   # integer optional
                :statement_url,
                :supplier,
                   # default_account_code   string optional
                   # default_vat_rate       string optional
                   # default_credit_terms   integer optional
                :customer
                   # default_account_code   string optional
                   # default_vat_rate       string optional
                   # default_credit_terms   integer optional

    # @!attribute [r] id
    # @return [Fixnum] Entity Id.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] statement_url
    # @return [String] The URL the customer/supplier can access to view statements.
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] company_name
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] contact_name
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] building
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] address1
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] address2
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] town
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] county
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] country
    # Optional. Country code.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] postcode
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] email
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] phone1
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] phone2
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] fax
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] website
    # Optional.
    # @return [String]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] external_id
    # Optional.
    # @return [Fixnum]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] supplier
    # Optional. [:default_account_code, :default_vat_rate, :default_credit_terms]
    # @return [Hash]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/

    # @!attribute [r] customer
    # Optional. [:default_account_code, :default_vat_rate, :default_credit_terms]
    # @return [Hash]
    # @see https://www.clearbooks.co.uk/support/api/docs/soap/createentity/


    # @fn         def initialize data {{{
    # @brief      Constructor of Entity class handling entity ie. personal data
    #
    # @param      [FIXME]     data        FIXME
    #
    def initialize data
      @id               = data.savon(:id).to_i
      @company_name     = data.savon :company_name
      @contact_name     = data.savon :contact_name

      @building         = data.savon :building
      @address1         = data.savon :address1
      @address2         = data.savon :address2
      @town             = data.savon :town
      @county           = data.savon :county
      @country          = data.savon :country
      @postcode         = data.savon :postcode

      @email            = data.savon :email
      @phone1           = data.savon :phone1
      @phone2           = data.savon :phone2
      @fax              = data.savon :fax
      @website          = data.savon :website

      @statement_url    = data.savon :statement_url
      @external_id      = data.savon(:external_id).to_i

      @supplier = entity_extra data.savon :supplier
      @supplier = @supplier.from_savon if @supplier

      @customer = entity_extra data.savon :customer
      @customer = @customer.from_savon if @customer

    end # }}}

    # @fn         def to_savon {{{
    # @brief      Converts given Entity (self) to savon readable format
    #
    # @return     [Hash]      Returns self as Savon readable Hash
    def to_savon
      {
        entity: {
          :@company_name  => @company_name,
          :@contact_name  => @contact_name,

          :@building      => @building,
          :@address1      => @address1,
          :@address2      => @address2,
          :@town          => @town,
          :@county        => @county,
          :@country       => @country,
          :@postcode      => @postcode,

          :@email         => @email,
          :@phone1        => @phone1,
          :@phone2        => @phone2,
          :@fax           => @fax,
          :@website       => @website,

          :@external_id   => @external_id,
          :supplier       => entity_extra(@supplier),
          :customer       => entity_extra(@customer)
        }.compact
      }
    end # }}}


    private

    # @fn         def entity_extra extra {{{
    # @brief      FIXME
    #
    # @param      [FIXME]       extra       FIXME
    #
    # @return     [FIXME]       FIXME
    def entity_extra extra
      if extra
        {
            :@default_account_code	=> extra[:default_account_code],
            :@default_vat_rate      => extra[:default_vat_rate],
            :@default_credit_terms  => extra[:default_credit_terms].to_i,
        }.compact
      end
    end # }}}


  end # of class Entity

end # of module Clearbooks


# vim:ts=2:tw=100:wm=100:syntax=ruby
