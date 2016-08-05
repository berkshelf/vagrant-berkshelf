require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do
  require 'rspec'

  RSpec.configure do |config|
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true

    config.order = 'random'
  end
end

Spork.each_run do
  require 'vagrant-berkshelf'
end
