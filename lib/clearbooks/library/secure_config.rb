#!/usr/bin/env ruby


# System includes
require 'secure_yaml'


# @class          class SecureConfig 
# @brief          Handles secure configs
class SecureConfig

  # @fn           def initialize filename, mode = :standard # {{{
  # @brief        Default constructor for SecureConfig
  #
  # @param        [String]        filename        Valid filename of a file we want to decrypt
  # @param        [Symbol]        mode            Default mode for SecureConfig
  def initialize filename, mode = :standard

    sane = check_sanity( filename )
    type = detect_type( filename )

    if mode == :standard
      if( type == :yaml )
        @contents = decrypt_yaml( filename )
      else
        raise NotImplementedError, "Don't know how to handle that file type (#{type.to_s})"
      end

    end # of if mode ==

  end # }}}

  # @fn           def check_sanity filename # {{{
  # @brief        Performs various checks on the file to ensure sanity
  #
  # @param        [String]        filename        Valid filename of a file we want to decrypt
  # @param        [Boolean]       strict          Strict checking, if enabled will terminate app if not correct
  #
  # @return       [Boolean]       True, if sane, false if soemthing is wrong
  def check_sanity filename, strict = true

    result = false

    raise ArgumentError, "File is not a file but a directory" if( File.directory?( filename ) )
    raise ArgumentError, "File is a socket" if( File.socket?( filename ) )

    raise ArgumentError, "File is not readable" unless( File.readable?( filename ) )
    raise ArgumentError, "File does not exist" unless( File.exists?( filename ) )
    raise ArgumentError, "File is empty" if( File.zero?( filename ) )

    if( strict )
      raise ArgumentError, "ENV[ 'PROPERTIES_ENCRYPTION_PASSWORD' ] missing - fatal error" if( ENV[ "PROPERTIES_ENCRYPTION_PASSWORD" ].nil? )
    else
      puts "(WW) Assuming empty PROPERTIES_ENCRYPTION_PASSWORD ! Decryption of secure yaml will fail !"
      ENV[ "PROPERTIES_ENCRYPTION_PASSWORD" ] = ""
    end



    result = true

    return result
  end # }}}

  # @fn           def detect_type filename = @filename # {{{
  # @brief        Detects file type
  #
  # @param        [String]        filename        Valid filename of a file we want to decrypt
  #
  # @return       [Function]
  def detect_type filename = @filename

    filename        = File.basename( filename )

    # sometimes files end in .yaml.encrypted
    filename.gsub!( ".encrypted", "" )
    extension       = filename.split( "." ).last
    response  = nil

    raise ArgumentError, "Error in guessing file type" if( extension.empty? )

    case extension
      when "yaml"
        response = :yaml
      else
        raise NotImplementedError, "Couldn't detect file type correctly"
    end

    return response
  end # }}}

  # @fn           def decrypt_yaml filename = @filename # {{{
  # @brief        Decrypts a given file
  #
  # @param        [String]        filename        Valid filename of a file we want to decrypt
  def decrypt_yaml filename = @filename

    password        = ENV[ "PROPERTIES_ENCRYPTION_PASSWORD" ]
    decrypted_yaml  = SecureYaml::load( File.open( filename ) )

    return decrypted_yaml
  end # }}}


  attr_reader :contents

end


# Direct Invocation
if __FILE__ == $0
end # of if __FILE__ == $0

# vim:ts=2:tw=100:wm=100
