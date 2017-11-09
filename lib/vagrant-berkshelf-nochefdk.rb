require 'vagrant'

require_relative 'vagrant-berkshelf/config'
require_relative 'vagrant-berkshelf/plugin'
require_relative 'vagrant-berkshelf/version'

module VagrantPlugins
  module Berkshelf
    def self.berkshelf_path
      ENV['BERKSHELF_PATH'] || File.expand_path('~/.berkshelf')
    end

    def self.shelves_path
      File.join(berkshelf_path, 'vagrant-berkshelf', 'shelves')
    end
  end
end
