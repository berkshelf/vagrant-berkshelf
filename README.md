# vagrant-berkshelf

[![Gem Version](https://badge.fury.io/rb/vagrant-berkshelf.png)](http://badge.fury.io/rb/vagrant-berkshelf)
[![Build Status](https://travis-ci.org/berkshelf/vagrant-berkshelf.png?branch=master)](https://travis-ci.org/berkshelf/vagrant-berkshelf)
[![Dependency Status](https://gemnasium.com/berkshelf/vagrant-berkshelf.png)](https://gemnasium.com/berkshelf/vagrant-berkshelf)

A Vagrant plugin to add Berkshelf integration to the Chef provisioners

## Installation

### Manually install Gecode (temporary)

The current release candidate of Vagrant Berkshelf requires you to have Gecode installed on your machine. In the future this process will be provided in an easy and automated fashion.

#### OSX

    $ cd $( brew --prefix )
    $ git checkout 3c5ca25 Library/Formula/gecode.rb
    $ brew install gecode

#### Debian and Ubuntu

    $ sudo apt-get install libgecode-dev

##### Source

    $ curl -O http://www.gecode.org/download/gecode-3.7.3.tar.gz
    $ tar zxvf gecode-3.7.3.tar.gz
    $ ./configure --disable-doc-dot \
        --disable-doc-search \
        --disable-doc-tagfile \
        --disable-doc-chm \
        --disable-doc-docset \
        --disable-qt \
        --disable-examples
    $ make
    $ (sudo) make install

### Vagrant & Plugin Installation

Install Vagrant 1.5.x from the [Vagrant downloads page](http://www.vagrantup.com/downloads.html)

Install the Vagrant Berkshelf plugin

    $ vagrant plugin install vagrant-berkshelf --plugin-version 2.0.0.rc2

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

Thank you to all of our [Contributors](https://github.com/berkshelf/vagrant-berkshelf/graphs/contributors), testers, and users.

If you'd like to contribute, please see our [contribution guidelines](https://github.com/berkshelf/vagrant-berkshelf/blob/master/CONTRIBUTING.md) first.
