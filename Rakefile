#!/usr/bin/env ruby

# System
require 'bundler'
require 'bundler/gem_tasks'

require 'shellwords'
require 'fileutils'
require 'yaml'

require 'date'
require 'ostruct'

require 'ronn'
require 'rdiscount'

require 'benchmark'
require 'wicked_pdf'


### Project Customization for Thor and Rake

project = YAML.load_file( '.project.yaml' )
project.each_pair { |name, value| self.instance_variable_set( "@#{name.to_s}", value ) }


### General

desc "Generate proper README file from templates" # {{{
task :readme do |t|
  source    = "README.md.template"
  target    = "README.md"

  content      = File.readlines( source ).collect!{ |line| line.rstrip }
  version   = `git describe --tags`.strip

  content[ content.index( "$Version$" ) ] = "Version " + version if( content.include?( "$Version$" ) )
  File.write( target, content.join("\n") )
  puts "(II) #{target.to_s} generated from #{source.to_s}"
end # }}}

desc "Generate Yardoc documentation for this project" # {{{
task :yardoc do |t|

  # Define new tags for yardoc to detect
  tags             = {}
  tags[ "module" ] = "Module"
  tags[ "class" ]  = "Class"
  tags[ "fn" ]     = "Function"
  tags[ "brief" ]  = "Description"

  # Hide tags we don't want in yardoc output
  hidden           = %w[module class fn]

  # Construct tag string for CLI command
  tags_line = ""
  tags.each_pair { |n,v| tags_line += " --tag #{n.to_s}:\"#{v.to_s}\"" }
  hidden.each { |h| tags_line += " --hide-tag #{h.to_s}" }

  puts "(II) Generating multi-file yardoc output written to doc/yardoc"
  system "yard --private --protected --markup-provider=redcarpet --markup=markdown #{tags_line.to_s} -o doc/yardoc lib/**/**/*.rb - LICENSE MAINTAINERS"

  puts "(II) Generating one-file yardoc output written to doc/yardoc_pdf"
  system "yard --private --protected --markup-provider=redcarpet --markup=markdown --one-file #{tags_line.to_s} -o doc/yardoc_pdf lib/**/**/*.rb - LICENSE MAINTAINERS"

  puts "(II) HTML to PDF written to doc/yardoc_pdf"
  pdf = WickedPdf.new.pdf_from_string( File.read( "doc/yardoc_pdf/index.html" ) )
  File.open 'doc/yardoc_pdf/index.pdf', 'wb' do |file|
    file << pdf
  end

end # }}}

desc "Generate Yard Graphs for this project" # {{{
task :yardgraph do |t|
  basedir = "doc/yard-graph"
  FileUtils.mkdir_p( basedir )
  system "yard graph --dependencies --empty-mixins --full > #{basedir.to_s}/graph.dot"
  system "dot -Tpng #{basedir.to_s}/graph.dot > #{basedir.to_s}/graph.png"
end # }}}

### Actions


### Helper Functions


### Load all Rake file tasks
Dir.glob( "{,lib/}#{@gem_name}/interface/rake/**/*.{rake,rb}" ) { |name| load name }


# vim:ts=2:tw=100:wm=100:syntax=ruby
