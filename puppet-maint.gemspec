# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-maint/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet-maint"
  spec.version       = PuppetMaint::VERSION
  spec.authors       = ["Liam Bennett"]
  spec.email         = ["liamjbennett@gmail.com"]
  spec.description   = %q{Maintenance tasks for Puppet}
  spec.summary       = %q{Maintenance tasks for Puppet}
  spec.homepage      = "https://github.com/liamjbennett/puppet-maint"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "json"
  spec.add_dependency "puppet"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "gem_publisher", "~> 1.3"
end
