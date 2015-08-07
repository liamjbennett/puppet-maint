require 'puppet-maint/resources/types'
require 'puppet-maint/resources/facts'
require 'puppet-maint/resources/functions'
require 'puppet-maint/resources/providers'

module PuppetMaint
  module Resources
    class Modules < Resource
      def defined
        modules = []
        File.open("Puppetfile") do |f|
          f.each_line do |line|
            if line.start_with?('mod')
              mod = line.split(" ")[1].gsub("'","").gsub('"',"").gsub(",","").split("/")[1]
              modules.push(mod)
            end
         end
        end
        return modules
      end

      def used(file)
        if file.include?("lib")
          selector = "lib"
        else
          selector = "manifests"
        end

        module_name = ""
        parts = file.split("/")
        parts.each_with_index do |item,i|
          if item.eql?(selector)
            module_name = parts[i-1]
          end
        end
        return module_name
      end

      #TODO: this method is funky and still needs refactoring
      def unused
        used_modules = []

        used_classes = PuppetMaint::Resources::Classes.new.used(PuppetMaint.module_dirs)
        used_classes.each do |c|
          used_modules.push(c[0].split("::")[0])
        end

        defines = PuppetMaint::Resources::Defines.new
        declared_defines = defines.declared(["modules/**/*.pp"])
        declared_types = PuppetMaint::Resources::Types.new.declared(["modules/*/lib/puppet/type/*.rb"])

        used_defines = defines.used(PuppetMaint.module_dirs)

        used_defines.each do |c|
          declared_defines.each do |d|
            if d[0].eql?(c[0])
              used_modules.push(used(d[1]))
            end
          end

          declared_types.each do |d|
            if d[0].eql?(c[0])
              used_modules.push(used(d[1]))
            end
          end
        end

        facts = PuppetMaint::Resources::Facts.new
        declared_facts = facts.declared(["modules/*/lib/facter/*.rb"])
        used_facts = facts.used(PuppetMaint.module_dirs)

        used_facts.each do |c|
          declared_facts.each do |d|
            if d[0].eql?(c[0])
              used_modules.push(used(d[1]))
            end
          end
        end

        functions = PuppetMaint::Resources::Functions.new
        declared_functions = functions.declared(["modules/*/lib/puppet/parser/functions/*.rb"])
        used_functions = functions.used(PuppetMaint.module_dirs)

        used_functions.each do |c|
          declared_functions.each do |d|
            if d[0].eql?(c[0])
              used_modules.push(used(d[1]))
            end
          end
        end

        providers = PuppetMaint::Resources::Providers.new
        declared_providers = providers.declared(["modules/*/lib/puppet/provider/**/*.rb"])
        used_providers = providers.used(PuppetMaint.module_dirs)

        used_providers.each do |c|
          declared_providers.each do |d|
            if d[0].eql?(c[0])
              used_modules.push(used(d[1]))
            end
          end
        end

        used_modules.uniq!

        modules = defined
        used_modules.each do |um|
          modules.reject! { |m| um.eql?(m) }
        end

        modules.sort!
      end
    end
  end
end
