# 4.0.3

* Bug Fixes
  * Enabled plugin state is only enabled if explicitly set to boolean `true`
  * Base setup occurs before Config validate, not after

# 4.0.2

* Bug Fixes
  * Don't check Berkshelf version if plugin is disabled

# 4.0.1

* Bug Fixes
  * Improved ability to find a Berksfile within a project

# 4.0.0

* Enhancements
  * Add support for chef-client local mode

* Bug Fixes
  * Chef Client provider configuration attributes are now properly read from a Berkshelf configuration file
  * Shared folder is no longer deleted and recreated on each provision
  * `berksfile_path` config option now defaults to CWD of Vagrantfile
  * Non-colored terminal output will be used when not available
  * VM's Berkshelf share will be cleaned up after destroying a VM

# 3.0.1

* Bug Fixes
  * Fix issue loading configuration from a Berkshelf config.json

# 3.0.0

* Enhancements
  * Now leverages the Berkshelf version installed by ChefDK
  * Installation process of plugin should be many, many times faster

* Bug Fixes
  * Fix many installation issues for Windows users
  * Fix warning output of berkshelf path when berkshelf is disabled but a Berksfile is present
  * Ensure default values for configuration are properly set

# 2.0.1

* Bug Fixes
  * Fix gem conflict issue when installing as a ruby gem

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
