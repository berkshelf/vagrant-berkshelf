require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do
  APP_ROOT = File.expand_path('../../', __FILE__)
  ENV["BERKSHELF_PATH"] = File.join(APP_ROOT, 'spec', 'tmp', 'berkshelf')

  require 'rspec'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true

    config.order = 'random'
  end
end

Spork.each_run do
  require 'berkshelf/vagrant'
end
