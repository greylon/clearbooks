module Clearbooks
  class Entity < Base
    attr_reader :company_name,	# string optional
                :contact_name,	# string optional
                :building, # string optional
                :address1, # string optional
                :address2, # string optional
                :town, # string optional
                :county, # string optional
                :country, # string optional
                  # country codes http://www.iso.org/iso/support/country_codes/iso_3166_code_lists/iso-3166-1_decoding_table.htm
                :postcode, # string optional
                :email, # string optional
                :phone1, # string optional
                :phone2, # string optional
                :fax, # string optional
                :website,	# string optional
                :external_id, # integer optional
                :supplier,
                 # default_account_code	string optional
                 # default_vat_rate	string optional
                 # default_credit_terms	integer optional
                :customer
                 # default_account_code	string optional
                 # default_vat_rate	string optional
                 # default_credit_terms	integer optional

    def initialize(data)
      @contact_name = data.savon :contact_name
      @building = data.savon :building
      @address1 = data.savon :address1
      @address2 = data.savon :address2
      @town = data.savon :town
      @county = data.savon :county
      @country = data.savon :country
      @postcode = data.savon :postcode
      @email = data.savon :email
      @phone1 = data.savon :phone1
      @phone2 = data.savon :phone2
      @fax = data.savon :fax
      @website = data.savon :website
      @external_id = data.savon(:external_id).to_i

      @supplier = data[:supplier].from_savon
      @customer = data[:customer].from_savon
    end

    def to_savon
      {
          entity: {
              @contact_name => @contact_name,
              @building => @building,
              @address1 => @address1,
              @address2 => @address2,
              @town => @town,
              @county => @county,
              @country => @country,
              @postcode => @postcode,
              @email => @email,
              @phone1 => @phone1,
              @phone2 => @phone2,
              @fax => @fax,
              @website => @website,
              @external_id => @external_id,
              supplier: {
                  @default_account_code	=> @supplier[:default_account_code],
                  @default_vat_rate => @supplier[:default_vat_code],
                  @default_credit_terms => @supplier[:default_credit_terms],
              },
              customer: {
                  @default_account_code	=> @supplier[:default_account_code],
                  @default_vat_rate => @supplier[:default_vat_code],
                  @default_credit_terms => @supplier[:default_credit_terms],
              }
          }
      }
    end
  end
end

