#!/usr/bin/env ruby

# System include
require 'yaml'


# @module     Clearbooks
# @brief      Handles Ruby idomatic expression of Clear Books SOAP API
module Clearbooks

  # @class    Configuration
  # @brief    Handles configurations of clearbooks gem such as api keys
  class Configuration

    attr_accessor :api_key, :wsdl, :log, :logger

    # @fn       def initialize
    # @brief    Constructor for Clearbooks::Configuration class objects
    def initialize
      defaults  = YAML.load_file(DEFAULT_CONFIG) rescue nil
      defaults  ||= YAML.load_file(File.expand_path("~/#{DEFAULT_CONFIG}")) rescue Hash.new

      @api_key  = ENV['CLEARBOOKS_API_KEY'] || defaults['api_key']
      @wsdl     = defaults['wsdl'] || 'https://secure.clearbooks.co.uk/api/wsdl/'
      @logger   = Logger.new(STDOUT) if @log = defaults['log']

      self
    end # }}}

  end # of module Configuration

end # of module Clearbooks

# vim:ts=2:tw=100:wm=100:syntax=ruby
