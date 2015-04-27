#!/usr/bin/env ruby


# System includes
require 'thor'

# Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/logger' )

# require File.expand_path( File.dirname( __FILE__ ) + '/../../../database/database' )
# require File.expand_path( File.dirname( __FILE__ ) + '/../../../database/general_database' )
# require File.expand_path( File.dirname( __FILE__ ) + '/../../../database/session_database' )
# require File.expand_path( File.dirname( __FILE__ ) + '/../../../database/redis_data_mapper' )


# @module     module Mixin
# @brief      Mixin module contains various functions to be used in other components
module Mixin

  # @module   Database Module
  # @brief    Module wrapper around database tasks
  module Database

    include ::Mixin::Logger

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super

      # Sanity
      raise ArgumentError, 'Cannot access logger' if( @logger.nil? )

      # Persistent database
      @logger.message( :debug, 'Creating General Database for persistent storage' )
      # @general_db         = GeneralDatabase.new( @options, @logger, @general_db_type, @general_db_path, @general_db_host, @general_db_username, @general_db_password )

      # Volatile database
      @logger.message( :debug, 'Creating Session Database for temporary storage' )
      # @session_db         = SessionDatabase.new( @options, @logger, @session_db_type, @session_db_path )

      #if( options[ :'overwrite-database' ] )
      #  @general_db.auto_migrate!
      #else
      #  @general_db.migrate_up!
      #end

    end # }}}


    # General (persistent) db
    Thor::class_option :'general-db-path', :type => :string, :required => false, :default => 'data/databases/clearbooks.sqlite3', :desc => 'Database URI'
    Thor::class_option :'general-db-type', :type => :string, :required => false, :default => 'sqlite3', :desc => 'Database type'
    Thor::class_option :'general-db-host', :type => :string, :required => false, :default => 'localhost', :desc => 'Database host'

    Thor::class_option :'general-db-username', :type => :string, :required => false, :default => '', :desc => 'Database username'
    Thor::class_option :'general-db-password', :type => :string, :required => false, :default => '', :desc => 'Database password'

    # Session (volatile) db
    Thor::class_option :'session-db-path', :type => :string, :required => false, :default => '', :desc => 'Database URI'
    Thor::class_option :'session-db-type', :type => :string, :required => false, :default => 'redis', :desc => 'Database type'
    Thor::class_option :'session-db-host', :type => :string, :required => false, :default => 'localhost', :desc => 'Database host'

    Thor::class_option :'session-db-username', :type => :string, :required => false, :default => '', :desc => 'Database username'
    Thor::class_option :'session-db-password', :type => :string, :required => false, :default => '', :desc => 'Database password'

    Thor::class_option :'overwrite-database', :type => :boolean, :required => false, :default => false, :desc => '*DESTROYS* Database'

    # Misc
    Thor::class_option :'use-dm-redis-adapter', :type => :boolean, :required => false, :default => false, :desc => 'If given uses, dm-redis-adapter gem instead of redis-objects'


  end # of Module Database

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
