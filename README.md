# Puppet-maint

Puppet-maint is a set of rake tasks built to aid in the maintenance of site or control repository.

## Installation

Add this line to your application's Gemfile:

    gem 'puppet-maint'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet-maint

## Usage

Include the following in your `Rakefile`:

    require 'puppet-maint/tasks/puppet-maint'

Test all manifests and templates relative to your `Rakefile`:

    ➜  puppet git:(master) bundle exec rake maint
    ---> maint:outdated
    ---> maint:unused_code
    ---> maint:unused_modules
    ---> maint:unused_nodes

## Configuration
Environment can be excluded with:

    PuppetMaint.exclude_environments = ["vagrant"]

For the `maint:unused_nodes` task you will need to configure your PuppetDB servers for lookup:

    PuppetMaint.db_servers = ["prod-puppetdb-01.mycorp.com"]

For the `maint:unused_modules` and `maint:unused_code` tasks you want want to configure additional directories conainting modules:

    PuppetMaint.module_dirs = [
      "app_modules/**/*.pp",
      "manifests/**/*.pp",
      "environments/**/*.pp",
      "roles/**/*.pp",
      "profiles/**/*.pp"
    ]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
