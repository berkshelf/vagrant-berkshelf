# 1.3.7

* Don't lock down activesupport since v3.2.14 already loosened the i18n requirement

# 1.3.6

* Replace Solve with RubyGems in Vagrant version checking. Fixes [#97](https://github.com/berkshelf/vagrant-berkshelf/issues/97) and backport it.

# 1.3.5

* Relax constraint on SSH to fix Vagrant 1.4 support

# 1.3.4

- Fix undefined constant error when provisioning with Vagrant AWS

# 1.2.0

- Rename to vagrant-berkshelf
- Trigger the plugin also on `vagrant reload`
- Check Vagrant version to see if it's supported
- cookbooks uploaded via chef_client will be forced and not frozen
- Fix bug with AWS provisioner
- Respect --no-provision flag

# 1.1.2

- Support Vagrant 1.2
- Plugin defaults to enabled, if Berksfile exists.

# 1.1.0

- Plugin defaults to disabled. Set 'config.berkshelf.enabled = true' in Vagrant config

# 1.0.0

- Separated Berkshelf Vagrant plugin into it's own gem (this one)
- Support Vagrant 1.1.x
