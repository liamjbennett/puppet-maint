require 'puppet-maint'
require 'rake'
require 'rake/tasklib'

module PuppetMaint
  class RakeTask < ::Rake::TaskLib
    def initialize(*args)

      desc "Run full maintenance report"
      task :maint => [
        'maint:outdated',
        'maint:unused_code',
        'maint:unused_modules',
        'maint:unused_nodes'
      ]

      namespace :maint do
        desc "Check for unused classes/defines"
        task :unused_code do |t|
          puts "---> #{t.name}"
          c = PuppetMaint::Code.new
          c.check
        end

        task :unused_modules do |t|
          puts "---> #{t.name}"
          m = PuppetMaint::Modules.new
          m.check
        end

        desc "Check for node definitions that no longer apply to any nodes"
        task :unused_nodes do |t|
          puts "---> #{t.name}"
          n = PuppetMaint::Nodes.new
          n.check
        end

        desc "Check for modules that need updating"
        task :outdated do |t|
          puts "---> #{t.name}"
          output = %x( librarian-puppet outdated )
          outdated = output.split("\n").delete_if {|x| x.start_with?("Module") or x.start_with?("Unable") }
          PuppetMaint.output("Outdated Modules", outdated)
        end
      end
    end
  end
end

PuppetMaint::RakeTask.new
