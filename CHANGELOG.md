# 1.2.0
- Trigger the plugin also on `vagrant reload`
- Check Vagrant version to see if it's supported
- cookbooks uploaded via chef_client will be forced and not frozen
- Fix bug with AWS provisioner

# 1.1.2
- Support Vagrant 1.2
- Plugin defaults to enabled, if Berksfile exists.

# 1.1.0
- Plugin defaults to disabled. Set 'config.berkshelf.enabled = true' in Vagrant config

# 1.0.0
- Separated Berkshelf Vagrant plugin into it's own gem (this one)
- Support Vagrant 1.1.x
