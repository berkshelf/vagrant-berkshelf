require 'rubygems'
require 'bundler'
require 'spork'

Spork.prefork do
  require 'rspec'

  RSpec.configure do |config|
    config.mock_with :rspec
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  require 'berkshelf/vagrant'
end
