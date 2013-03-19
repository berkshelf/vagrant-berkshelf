require 'rubygems'
require 'bundler'
require 'spork'

Spork.prefork do
  APP_ROOT = File.expand_path('../../', __FILE__)
  ENV["BERKSHELF_PATH"] = File.join(APP_ROOT, 'spec', 'tmp', 'berkshelf')

  require 'rspec'

  RSpec.configure do |config|
    config.mock_with :rspec
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true

    config.around(:each) do
      clean_tmp_path
    end
  end

  def clean_tmp_path
    FileUtils.rm_rf(tmp_path)
    FileUtils.mkdir_p(tmp_path)
  end

  def tmp_path
    File.join(APP_ROOT, 'spec', 'tmp')
  end
end

Spork.each_run do
  require 'berkshelf/vagrant'
end
