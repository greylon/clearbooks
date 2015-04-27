require 'yaml'

module Clearbooks
  class Configuration
    attr_accessor :api_key, :wsdl, :log, :logger

    def initialize
      defaults = YAML.load_file(DEFAULT_CONFIG) rescue {}

      @api_key = ENV['CLEARBOOKS_API_KEY'] || defaults['api_key']
      @wsdl = defaults['wsdl'] || 'https://secure.clearbooks.co.uk/api/wsdl/'
      @logger = Logger.new(STDOUT) if @log = defaults['log']

      self
    end
  end
end