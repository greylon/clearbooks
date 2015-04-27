#!/usr/bin/env ruby


# System includes
require 'openssl'
require 'scrypt'


# @class        class Password
# @brief        Password calculation function which takes cleartext and returns a computed reference password.
# @detailed     Password calculation function. It takes a clear text input password and computes the reference
#               password we want to compare to in the database. The encryption function used is
#               scrypt, which has greater advantages over bcrypt and pbkdf2. Lets not even compare
#               that to SHA + salt.
class Password

  # @fn         def initialize password = nil # {{{
  # @brief      The constructor for the password class
  def initialize

    # Sanity check # {{{
    # }}}

    # Main

    # These values make the login process extremely costly to compromise for the next 5-10 years.
    #
    # :max_time specifies the maximum number of seconds the computation should take.
    @max_time         = 3

    # :max_mem specifies the maximum number of bytes the computation should take. A value of 0 specifies no upper limit. The minimum is always 1 MB.
    @max_mem          = 2 * 1048576  # we use 2 MB per login

    # :max_memfrac specifies the maximum memory in a fraction of available resources to use. Any value equal to 0 or greater than 0.5 will result in 0.5 being used.
    @max_memfrac      = 1.0

    # Make sure we deal with only a sane value which can't affect our code
    # @sha512       = OpenSSL::Digest::Digest.new('sha512')
    # password      = @sha512.digest( us_password.to_s )    # a bit overkill, but we don't want to deal with un/escaped html sequences

    @scrypt           = nil
    @value            = nil
  end # def initialize # }}} 

  # @fn         def generate # {{{
  # @brief      Generate takes the provided password and generates a scrypt version for database comparsion
  #
  # @param      [String]        password        Password string as given by the user
  #
  # @returns    [String]                        Returns the hash of the password you want to store in the database
  def generate password = @password

    # Input verification {{{
    raise ArgumentError, "Password cannot be nil" if( password.nil? )
    raise ArgumentError, "Password must be string" unless( password.is_a?( String ) )
    raise ArgumentError, "Password cannot be empty" if( password.empty? )
    # }}}

    # Main flow
    result = nil

    @scrypt           = SCrypt::Password.create( password, :max_time => @max_time, :max_mem => @max_mem, :max_memfrac => @max_memfrac )
    @value            = @scrypt.to_s

    # Sanity check
    raise ArgumentError, "Password needs to be greater or equal to 90 characters" unless( @value.to_s.length >= 89 )

    return @value
  end # def generate # }}}

  # @fn         def load_password hash = nil # {{{
  # @brief      Loads the hash back into a scrypt password class for verfication against a secret
  #
  # @param      [String]        hash            Secret we stored in the database
  #
  # @returns    [Boolean]                       Returns true if successful, false if not
  def load_hash hash = nil

    # Input verification {{{
    raise ArgumentError, "Hash cannot be nil" if( hash.nil? )
    raise ArgumentError, "Hash must be of type string" unless( hash.is_a?(String) )

    # FIXME
    # e.g. 800$8$90$12ccb6e0fecf19317f7486e8c72197b557d9b44e$413490fc9b3e92232cdf9ddaf5bb1fbd834fdae8
    # This contains all the necessary max_time, etc. variables as well as the password hash itself
    # raise ArgumentError, "Invalid Hash provided" if( hash.match(/^[0-9a-z]+\$[0-9a-z]+\$[0-9a-z]+\$[A-Za-z0-9]{20,}\$[A-Za-z0-9]{20,}$/).nil? )
    # }}}

    # Main flow
    result            = false
    @scrypt           = SCrypt::Password.new( hash )
    result            = true if( @scrypt.is_a?( SCrypt::Password ) )

    result
  end # def load_hash hash = nil # }}}

  # @fn         def ==( user_password ) # {{{
  # @brief      Compares the loaded SCrypt::Password with the clear text given from the user. If correct returns true otherwise false.
  #
  # @param      [String]        user_password     Password string given by the user
  #
  # @returns    [Boolean]                         Returns true if successful, false if not
  def ==( user_password )
    raise ArgumentError, "@scrypt_class cannot be nil" if( @scrypt.nil? )

    @scrypt == user_password
  end # def ==( user_password ) }}}

  # @fn         def compare hash = nil, password = nil # {{{
  # @brief      Compares a given hash and cleartext password for equality. Returns true if same, false if not.
  #
  # @param      [String]        hash              Secret we stored in the database
  # @param      [String]        user_password     Password string given by the user in cleartext
  #
  # @returns    [Boolean]                         Returns true if successful, false if not
  def compare hash = nil, password = nil

    # Input verifcation {{{
    raise ArgumentError, "Hash cannot be nil" if( hash.nil? )
    raise ArgumentError, "Password cannot be nil" if( password.nil? )
    raise ArgumentError, "Hash must be a string" unless( hash.is_a?( String ) )
    raise ArgumentError, "Password must be a string" unless( password.is_a?( String ) )
    raise ArgumentError, "Hash cannot be empty" if( hash.empty? )
    raise ArgumentError, "Password cannot be empty" if( password.empty? )
    # }}}

    # Main flow
    equal         = false
    loaded        = load_hash( hash )
 
    if( loaded )
     if( @scrypt == password )
        equal         = true
      else
        # FIXME use logger here
      end
    end

    return equal
  end # def ==( user_password ) }}}


  attr_reader :value

end # of class Password


# = Direct Invocation testing
if __FILE__ == $0

  # First time run
  secret    = "My cool secret"
  password  = Password.new     # takes <5sec (very secure)
  password.generate( secret )
  hash      = password.value

  puts "The Hash we generated is :"
  p hash

  # Re-run for check
  password = Password.new     # takes <5sec (very secure)
  password.load_hash( hash )
  puts "The user provided secret and the password hash from the db are the same" if( password == secret )

  # More high-level
  password = Password.new
  result   = password.compare( hash, secret )
  puts "The user provided secret and the password hash from the db are the same" if( result )

end # of if __FILE__ == $0


# vim:ts=2:tw=100:wm=100

