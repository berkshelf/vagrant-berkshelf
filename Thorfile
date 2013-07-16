# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'bundler'
require 'bundler/setup'
require 'thor/rake_compat'

require 'berkshelf/vagrant'

class Gem < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  GEM_PKG = "vagrant-berkshelf-#{Berkshelf::Vagrant::VERSION}.gem".freeze

  desc "build", "Build #{GEM_PKG} into the pkg directory"
  def build
    Rake::Task["build"].execute
  end

  desc "release", "Create tag v#{Berkshelf::Vagrant::VERSION} and build and push #{GEM_PKG} to Rubygems"
  def release
    Rake::Task["release"].execute
  end

  desc "install", "Build and install #{GEM_PKG} into system gems"
  def install
    Rake::Task["install"].execute
  end
end

class Spec < Thor
  include Thor::Actions
  default_task :unit

  desc "plug", "Install #{GEM_PKG} into vagrant"
  def plug
    build
    run "vagrant plugin install pkg/#{GEM_PKG}"
  end

  desc "ci", "Run all possible tests on Travis-CI"
  def ci
    ENV['CI'] = 'true' # Travis-CI also sets this, but set it here for local testing
    invoke(:unit)
  end

  desc "unit", "Run unit tests"
  def unit
    unless run_unit
      exit 1
    end
  end

  no_tasks do
    def run_unit(*flags)
      run "rspec --color --format=documentation #{flags.join(' ')} spec"
    end
  end
end
