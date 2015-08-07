require 'puppet-maint/resources/classes'
require 'puppet-maint/resources/defines'

module PuppetMaint
  class Code
    def check
      PuppetMaint.output(:CLASS, PuppetMaint::Resources::Classes.new.unused(PuppetMaint.module_dirs))
      PuppetMaint.output(:DEFINE,  PuppetMaint::Resources::Defines.new.unused(PuppetMaint.module_dirs))
    end
  end
end
