# 2.0.0

* Enhancements
  * Support Berkshelf 3.0
  * Support Vagrant 1.5.x

# 1.3.4

* Bug Fixes
  * Fix undefined constant error when provisioning with Vagrant AWS

# 1.2.0

* Breaking Changes
  * Rename to vagrant-berkshelf

* Enhancements
  * Trigger the plugin also on `vagrant reload`
  * Check Vagrant version to see if it's supported
  * cookbooks uploaded via chef_client will be forced and not frozen
  * Respect --no-provision flag

* Bug Fixes
  * Fix bug with AWS provisioner

# 1.1.2

* Enhancements
  * Support Vagrant 1.2
  * Plugin defaults to enabled, if Berksfile exists.

# 1.1.0

* Enhancements
  * Plugin defaults to disabled. Set 'config.berkshelf.enabled = true' in Vagrant config

# 1.0.0

* Breaking Changes
  * Separated Berkshelf Vagrant plugin into it's own gem (this one)

* Enhancements
  * Support Vagrant 1.1.x
