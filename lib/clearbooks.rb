#!/usr/bin/env ruby


# Standard library includes
require 'bundler'
require 'thor'
require 'rake'

# Custom library includes
require_relative 'clearbooks/core_ext'


# @module         module Clearbooks
# @brief          Clearbooks modules and classes namespace
module Clearbooks

  require_relative 'clearbooks/version'
  require_relative 'clearbooks/error'

  # @module     module Mixin
  # @brief      Mixin module contains various functions to be used in other components
  module Mixin

    # autoload :Guess, 'clearbooks/mixin/'

  end # of module Mixing

  # autoload :Cache,      'clearbooks/library/cache'
  # autoload :Choice,     'clearbooks/library/choice'


  DEFAULT_CONFIG      = '.clearbooks/config.yaml'.freeze

  class << self

  end # of class << self

end # of module Clearbooks


# if ARGV[0].match 'discovery:'
#   Discovery.start
# else
#   Default.start
# end

## Library
require_relative 'clearbooks/library/dbc'
require_relative 'clearbooks/library/helpers'
require_relative 'clearbooks/library/logger'
require_relative 'clearbooks/library/secure_config'


# vim:ts=2:tw=100:wm=100:syntax=ruby
