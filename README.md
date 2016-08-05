# Vagrant Berkshelf Plugin

[![Gem Version](http://img.shields.io/gem/v/vagrant-berkshelf.svg)][gem] [![Build Status](http://img.shields.io/travis/berkshelf/vagrant-berkshelf.svg)][travis]

Vagrant Berkshelf is a Vagrant plugin that adds Berkshelf integration to the Chef provisioners. Vagrant Berkshelf will automatically download and install cookbooks onto the Vagrant Virtual Machine.

## Installation

1. Install the latest version of [Vagrant](https://www.vagrantup.com/downloads.html)
2. Install the latest version of [ChefDK](https://downloads.chef.io/chef-dk/)
3. Install the Vagrant Berkshelf plugin:

  ```sh
  $ vagrant plugin install vagrant-berkshelf
  ```

## Usage

If the Vagrant Berkshelf plugin is installed, it will intelligently detect when a Berksfile is present in the same working directory as the Vagrantfile.

Here is an example Vagrantfile configuration section for Vagrant Berkshelf:

```ruby
Vagrant.configure("2") do |config|
  # The path to the Berksfile to use. The default value is "Berksfile" if one
  # exists, or nil if it does not.
  config.berkshelf.berksfile_path = "custom.Berksfile"

  # Enable Berkshelf. If a Berksfile exists or a berksfile_path is given, this
  # value is automatically set to true. If not, the value is false
  config.berkshelf.enabled = true

  # A list of Berkshelf groups to only install and sync to the Vagrant Virtual
  # Machine. The default value is an empty array.
  config.berkshelf.only = ["group_a", "group_b"]

  # A list of Berkshelf groups to not install and sync to the Vagrant Virtual
  # Machine. The default value is an empty array.
  config.berkshelf.except = ["group_c", "group_d"]

  # A list of extra values to pass to the `berks` executable. The default value
  # is an empty array.
  config.berkshelf.args = ["--format json"]
end
```

## Contributing

Thank you to all of our [Contributors](https://github.com/berkshelf/vagrant-berkshelf/graphs/contributors), testers, and users.

- Please report issues [on the GitHub issue tracker](https://github.com/berkshelf/berkshelf/issues)
- Hangout with us in #chef or #berkshelf on freenode

If you'd like to contribute, please see our [contribution guidelines](https://github.com/berkshelf/vagrant-berkshelf/blob/master/CONTRIBUTING.md) first.

## License & Authors

- Jamie Winsor (jamie@vialstudios.com)
- Michael Ivey (michael.ivey@riotgames.com)
- Seth Vargo (sethvargo@gmail.com)

```text
Copyright (c) 2012-2014 Riot Games

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[gem]: https://rubygems.org/gems/vagrant-berkshelf
[travis]: https://travis-ci.org/berkshelf/vagrant-berkshelf
