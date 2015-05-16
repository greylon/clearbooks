#!/usr/bin/env ruby

# System include
require 'yaml'
require 'andand'
require 'logger'


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Configuration
  # @brief    Handles configurations of clearbooks gem such as api keys
  class Configuration
    attr_accessor :api_key, :wsdl, :log, :logger, :log_level

    # @fn       def initialize
    # @brief    Constructor for Clearbooks::Configuration class objects
    def initialize
      defaults  = YAML.load_file(DEFAULT_CONFIG) rescue nil
      defaults  ||= YAML.load_file(File.expand_path("~/#{DEFAULT_CONFIG}")) rescue Hash.new

      @api_key = ENV['CLEARBOOKS_API_KEY'] || defaults['api_key']
      @wsdl = defaults['wsdl'] || 'https://secure.clearbooks.co.uk/api/wsdl/'
      @log = defaults['log'] || false
      @logger = Logger.new(STDOUT)
      @log_level = defaults['log_level'].andand.to_sym || :info
      self
    end # }}}

  end # of module Configuration

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
