#!/usr/bin/env ruby

# Make sure load path contains local + global
$LOAD_PATH << '.'
$LOAD_PATH << 'lib'


# System includes
require 'bundler'

require 'fileutils'


# Make Thor scripts debug-able, e.g. ruby -r debug -- Thorfile
require 'thor' unless defined? Thor::Runner
require 'thor/rake_compat'

# @class        class Default < Thor
# @brief        Default Tasks for Thor, with thight Rake integration
class Default < Thor

  include Thor::RakeCompat

  Bundler::GemHelper.install_tasks

  ## Rake Task bindings

  # @fn         def build # {{{
  # @brief      Build clearbooks gem
  #
  desc "build", "Build clearbooks-#{Clearbooks::VERSION}.gem into the pkg directory"
  def build
    Rake::Task["build"].execute
  end # }}}

  # @fn         def clean # {{{
  # @brief      Clean clearbooks gem generated ressources
  #
  desc "clean", "Clean clearbooks-#{Clearbooks::VERSION}.gem generated files from current directories"
  def clean
    Rake::Task["clean"].execute
  end # }}}

  # @fn         def install {{{
  # @brief      Build and install clearbooks gem into system gems
  desc "install", "Build and install clearbooks-#{Clearbooks::VERSION}.gem into system gems"
  def install
    Rake::Task["install"].execute
  end # }}}

  # @fn         def release {{{
  # @brief      Build, Tag and push built gem into internal repository
  desc "release", "Create tag v#{Clearbooks::VERSION} and build and push clearbooks-#{Clearbooks::VERSION}.gem to internal gems repository"
  def release
    not ImplementedError # we can push to rubygems since its closed!
    # Rake::Task["release"].execute
  end # }}}

  # @fn         def spec {{{
  # @brief      Run RSpec unit tests
  desc "spec", "Run RSpec code examples"
  def spec
    exec "rspec spec"
  end # }}}

end # of class Default

# Project Customization for Thor and Rake
project = YAML.load_file( '.project.yaml' )
project.each_pair { |name, value| self.instance_variable_set( "@#{name.to_s}", value ) }

# Load all Thor/Rake file tasks
Dir.glob( "{,lib/}#{@gem_name}/interface/thor/**/*.{thor,rb}" ) { |name| Thor::Util.load_thorfile name }
Dir.glob( "{,lib/}#{@gem_name}/interface/rake/**/*.{rake,rb}" ) { |name| load name }


# vim:ts=2:tw=100:wm=100:syntax=ruby
