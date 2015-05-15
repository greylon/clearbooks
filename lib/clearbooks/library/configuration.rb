require 'yaml'
require 'andand'
require 'logger'

module Clearbooks
  class Configuration
    attr_accessor :api_key, :wsdl, :log, :logger, :log_level

    def initialize
      defaults = YAML.load_file(DEFAULT_CONFIG) rescue nil
      defaults ||= YAML.load_file(File.expand_path("~/#{DEFAULT_CONFIG}")) rescue Hash.new

      @api_key = ENV['CLEARBOOKS_API_KEY'] || defaults['api_key']
      @wsdl = defaults['wsdl'] || 'https://secure.clearbooks.co.uk/api/wsdl/'
      @log = defaults['log'] || false
      @logger = Logger.new(STDOUT)
      @log_level = defaults['log_level'].andand.to_sym || :info
      self
    end
  end
end

