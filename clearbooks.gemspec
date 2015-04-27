# File: clearbooks.gemspec
# coding: utf-8


# Make sure lib is in Load path
lib = File.expand_path( '../lib/', __FILE__ )
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?( lib )

# System includes
require 'date'

# Custom includes
require 'clearbooks/version'

Gem::Specification.new do |spec|

  spec.name                 = 'clearbooks'

  spec.description          = %q(Unofficial Clear Books PLC (https://www.clearbooks.co.uk) gem handling all interactions of their SOAP API via native Ruby interface)
  spec.summary              = spec.description

  spec.authors              = [ 'Bjoern Rennhak', 'Oleg Kukareka' ]
  spec.email                = [ 'bjoern@greylon.com', 'oleg@kukareka.com' ]

  spec.homepage             = 'http://github.com/greylon/clearbooks'

  spec.licenses             = %w[MIT]

  spec.date                 = DateTime.now.to_s.split( 'T' ).first
  spec.version              = Clearbooks::VERSION
  spec.platform             = Gem::Platform::RUBY

  spec.metadata             = {
                                'issue_tracker' =>  'http://github.com/greylon/clearbooks/issues'
                              }

  spec.bindir               = 'bin'
  spec.executables          = %w[clearbooks]

  spec.require_paths        = %w[lib]

  spec.files                = %w[
                                  AUTHORS.md
                                  CHANGELOG.md
                                  COPYING.md
                                  FAQ.md
                                  LICENSE.md
                                  MAINTAINERS.md
                                  Gemfile
                                  README.md
                                  Rakefile
                                  Thorfile
                                  clearbooks.gemspec
                                ]

  spec.files                += Dir.glob( 'bin/**/*' )

  spec.files                += Dir.glob( 'lib/**/*.rb' )
  spec.files                += Dir.glob( 'lib/**/*.thor' )

  spec.files                += Dir.glob( 'spec/**/*' )

  spec.files                += Dir.glob( 'data/**/*' )

  spec.files                += Dir.glob( 'documentation/**/*' )

  spec.files                += Dir.glob( 'examples/**/*' )

  spec.files                += Dir.glob( 'base/**/*' )

  spec.test_files           += Dir.glob( 'test/**/*' )
  spec.test_files           += Dir.glob( 'spec/**/*' )
  spec.test_files           += Dir.glob( 'features/**/*' )

  ## Dependencies

  # Ruby VM
  spec.required_ruby_version  = '~> 2.2'

  # General
  spec.add_runtime_dependency 'thor'

  # Middlewares
  spec.add_runtime_dependency 'savon'

  # Package building
  spec.add_runtime_dependency 'fpm'

  # Shell
  spec.add_runtime_dependency 'ptools'
  spec.add_runtime_dependency 'os'

  # Encryption / Security
  spec.add_runtime_dependency 'bcrypt-ruby'
  spec.add_runtime_dependency 'scrypt'

  # Data RPCs and Messaging
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'mime-types'

  # Data Exchange Containers/Parsing
  spec.add_runtime_dependency 'oj'
  spec.add_runtime_dependency 'ox'
  # spec.add_runtime_dependency 'nokogiri'
  # spec.add_runtime_dependency 'hpricot'
  # spec.add_runtime_dependency 'cobravsmongoose'

  # Caching
  spec.add_runtime_dependency 'moneta'

  # l10n
  spec.add_runtime_dependency 'gettext'

  # Monadic/Functional
  spec.add_runtime_dependency 'andand'
  spec.add_runtime_dependency 'ick'

  # Misc System
  spec.add_runtime_dependency 'awesome_print'
  spec.add_runtime_dependency 'ntp'
  spec.add_runtime_dependency 'uuid'
  spec.add_runtime_dependency 'money'

  ## System libraries needed (info for the user)
  # spec.requirements 'iconv zlib libmagic'


  ## Post Install
  spec.post_install_message = <<-EOS
                                                             
      ____ _     _____    _    ____  ____   ___   ___  _  ______  
     / ___| |   | ____|  / \  |  _ \| __ ) / _ \ / _ \| |/ / ___| 
    | |   | |   |  _|   / _ \ | |_) |  _ \| | | | | | | ' /\___ \ 
    | |___| |___| |___ / ___ \|  _ <| |_) | |_| | |_| | . \ ___) |
     \____|_____|_____/_/   \_\_| \_\____/ \___/ \___/|_|\_\____/ 
                                                             

    (c) #{spec.date.to_s}, All rights reserved
    Bjoern Rennhak, Greylon Ltd.

    Don't forget to configure $HOME/.clearbooks/config.
    To generate config file under $HOME/.clearbooks/ directory,
    please run 'clearbooks config:generate' command

    Thanks for installing unofficial Clearbooks Gem !
  EOS

end # of Gem::Specification.new do |s|


# vim:ts=2:tw=100:wm=100:syntax=ruby
