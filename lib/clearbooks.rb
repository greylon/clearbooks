#!/usr/bin/env ruby


# Standard library includes
require 'bundler'
require 'thor'
require 'rake'

# Custom library includes
require_relative 'clearbooks/core_ext'
require_relative 'clearbooks/version'
require_relative 'clearbooks/error'


# @module         module Clearbooks
# @brief          Clearbooks modules and classes namespace
module Clearbooks

  DEFAULT_CONFIG = '.clearbooks/config.yaml'.freeze


  autoload :Client,         'clearbooks/library/client'
  autoload :Configuration,  'clearbooks/library/configuration'

  autoload :Base,           'clearbooks/model/base'
  autoload :Invoice,        'clearbooks/model/invoice'
  autoload :Item,           'clearbooks/model/item'
  autoload :Entity,         'clearbooks/model/entity'
  autoload :Project,        'clearbooks/model/project'
  autoload :AccountCode,    'clearbooks/model/account_code'
  autoload :Journal,        'clearbooks/model/journal'
  autoload :Ledger,         'clearbooks/model/ledger'
  autoload :Payment,         'clearbooks/model/payment'

  class << self

    # @fn       def client {{{
    # @brief    Clearbooks client instance. You can use static methods in Clearbooks module instead of referring to the client instance.
    #
    # @example  Clearbooks.list_invoices
    #           # or
    #           Clearbooks.client.list_invoices
    def client
      @client ||= Client.new
    end # }}}

    # @fn       def config {{{
    # @brief    Clearbooks configuration
    #
    # @return   [Configuration]     Returns Configuration object
    def config
      @config ||= Configuration.new
    end # }}}

    # @fn       def configure {{{
    # @brief    Use a block syntax to configure the gem
    #
    # @return   [Hash]    Returns Configuration object
    #
    # @example  Clearbooks.configure do |config|
    #             config.api_key = 'api_key'
    #             config.log = true
    #             config.logger = Logger.new(STDOUT)
    #           end
    def configure
      yield config
    end # }}}

    # @fn       def method_missing method, *args, &block {{{
    # @brief    Duck typing response for Clearbooks missing methods behavior
    #
    # @param    [String]            method      Some unknown method call on Clearbooks class
    # @param    [Array]             args        Some given function arguments with given method call
    # @param    [Explicit Block]    block       Some given block argument with the function and arguments
    #
    def method_missing method, *args, &block
      client.send method, *args, &block
    end # }}}

    # @fn       def respond_to? *args {{{
    # @brief    Duck typing response for Clearbooks method queries
    #
    # @param    [Array]       args        Function and function parameter argument list
    #
    def respond_to? *args
      super || client.respond_to?(*args)
    end # }}}

  end # of class << self

end # of module Clearbooks


# vim:ts=2:tw=100:wm=100:syntax=ruby
