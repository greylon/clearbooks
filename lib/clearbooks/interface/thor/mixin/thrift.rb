#!/usr/bin/env ruby


# System includes
require 'thor'
require 'andand'


# @module     module Mixin
# @brief      Mixin module contains various functions to be used in other components
module Mixin

  # @module   Thrift Module
  # @brief    Module wrapper around apache thrift tasks
  module Thrift

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super
    end # }}}

    Thor::class_option :'thrift-host', :type => :string, :required => false, :default => 'localhost', :desc => 'Hostname used run Apache Thrift server'
    Thor::class_option :'thrift-port', :type => :numeric, :required => false, :default => 7050, :desc => 'Port used run Apache Thrift server'

    Thor::class_option :'thrift-port-pool-range', :type => :array, :required => false, :default => [ 7050 ], :desc => 'Port range used run Apache Thrift server'
    Thor::class_option :'thrift-port-pool', :type => :boolean, :required => false, :default => false, :desc => 'Use port range to run Apache Thrift server'

  end # of module Thrift

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
