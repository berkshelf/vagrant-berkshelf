# vagrant-berkshelf
[![Gem Version](https://badge.fury.io/rb/vagrant-berkshelf.png)](http://badge.fury.io/rb/vagrant-berkshelf)
[![Build Status](https://travis-ci.org/RiotGames/vagrant-berkshelf.png?branch=master)](https://travis-ci.org/RiotGames/vagrant-berkshelf)
[![Dependency Status](https://gemnasium.com/RiotGames/vagrant-berkshelf.png)](https://gemnasium.com/RiotGames/vagrant-berkshelf)
[![Code Climate](https://codeclimate.com/github/RiotGames/vagrant-berkshelf.png)](https://codeclimate.com/github/RiotGames/vagrant-berkshelf)

A Vagrant plugin to add Berkshelf integration to the Chef provisioners

## Installation

Install Vagrant 1.2.x from the [Vagrant downloads page](http://downloads.vagrantup.com/)

Install the Vagrant Berkshelf plugin

    $ vagrant plugin install vagrant-berkshelf

## Usage

Once the Vagrant Berkshelf plugin is installed it can be enabled in your Vagrantfile

    Vagrant.configure("2") do |config|
      ...
      config.berkshelf.enabled = true
      ...
    end

The plugin will look in your current working directory for your `Berksfile` by default. Just ensure that your Berksfile exists and when you run `vagrant up`, `vagrant provision`, or `vagrant destroy` the Berkshelf integration will automatically kick in!

# Authors
- Jamie Winsor (<jamie@vialstudios.com>)
- Michael Ivey (<michael.ivey@riotgames.com>)

Thank you to all of our [Contributors](https://github.com/RiotGames/vagrant-berkshelf/graphs/contributors), testers, and users.

If you'd like to contribute, please see our [contribution guidelines](https://github.com/RiotGames/vagrant-berkshelf/blob/master/CONTRIBUTING.md) first.
