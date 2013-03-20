# Berkshelf::Vagrant
[![Gem Version](https://badge.fury.io/rb/berkshelf-vagrant.png)](http://badge.fury.io/rb/berkshelf-vagrant)
[![Build Status](https://travis-ci.org/RiotGames/berkshelf-vagrant.png?branch=master)](https://travis-ci.org/RiotGames/berkshelf-vagrant)
[![Dependency Status](https://gemnasium.com/RiotGames/berkshelf-vagrant.png)](https://gemnasium.com/RiotGames/berkshelf-vagrant)
[![Code Climate](https://codeclimate.com/github/RiotGames/berkshelf-vagrant.png)](https://codeclimate.com/github/RiotGames/berkshelf-vagrant)

A Vagrant plugin to add Berkshelf integration to the Chef provisioners

## Installation

Install Vagrant 1.1.x from the [Vagrant downloads page](http://downloads.vagrantup.com/)

Install the Berkshelf Vagrant plugin

    $ vagrant plugin install berkshelf-vagrant

## Usage

The Berkshelf Vagrant plugin automatically hooks into the Vagrant provisioning middleware; theres no need to perform any additional steps after installation.

Just ensure that you have a Berksfile in the directory with your Vagrantfile and when you run `vagrant up`, `vagrant provision`, or `vagrant destroy` the Berkshelf integration will automatically kick in!

# Authors
- Jamie Winsor (<reset@riotgames.com>)

Thank you to all of our [Contributors](https://github.com/RiotGames/berkshelf-vagrant/graphs/contributors), testers, and users.

If you'd like to contribute, please see our [contribution guidelines](https://github.com/RiotGames/berkshelf-vagrant/blob/master/CONTRIBUTING.md) first.
