#!/usr/bin/env ruby


# System includes
require 'fileutils'

#Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/mixin/default_config' )

# @fn     class Generate < Thor
# @brief  Generate config files
class Config < Thor

  # Include various partials
  include Thor::Actions
  include ::Mixin::DefaultConfig


  desc "generate", "Generate clearbooks config file" # {{{

  option :url,      desc: "Clearbooks url"
  option :ip,       desc: "Clearbooks ip"
  option :port,     desc: "Clearbooks port"
  option :username, desc: "Clearbooks username"
  option :password, desc: "Clearbooks password"
  option :token,    desc: "Clearbooks token"

  def generate
    template_path = Thor::Sandbox::Config.source_root(File.expand_path( File.dirname( __FILE__ ) + '/../../template/config.tt'))
    config        = defaults['clearbooks'].merge(options)
    template(template_path, File.expand_path( '~/.clearbooks/config.yml' ), config)
  end # }}}

  desc "clean", "Removes clearbooks config file" # {{{
  def clean
    config_path = File.expand_path( '~/.clearbooks/config.yml' )
    File.delete(config_path) if( File.exist?(config_path) )
  end # }}}

end # of class Generate < Thor

# vim:ts=2:tw=100:syntax=ruby
