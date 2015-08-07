require 'puppet-maint/resources/modules'

module PuppetMaint
  class Modules
    def check
      PuppetMaint.output("Modules", PuppetMaint::Resources::Modules.new.unused)
    end
  end
end
