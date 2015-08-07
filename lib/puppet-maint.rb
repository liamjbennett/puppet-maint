require 'puppet-maint/code'
require 'puppet-maint/modules'
require 'puppet-maint/nodes'
require 'puppet-maint/resource'
require 'puppet'

module PuppetMaint

  @db_servers = []
  @exclude_environments = []
  @module_dirs = [
    "manifests/**/*.pp",
    "environments/**/*.pp",
    "roles/**/*.pp",
    "profiles/**/*.pp"
  ]

  class << self
    attr_accessor :module_dirs, :db_servers, :exclude_environments

    def tokenize(file)
      lexer = Puppet::Parser::Lexer.new
      lexer.string = File.read(file)
      lexer.fullscan
    end

    def output(type, collection, show_file=nil)
      puts "Unused #{type} (#{collection.length}):" if collection.length > 0
      collection.each do |t, f|
        line = "  #{t}"
        line += " in #{f}" if show_file
        puts line
      end
    end

  end

end
