require 'vagrant/ui'

module VagrantPlugins
  module Berkshelf
    class Env
      # @return [String]
      attr_accessor :shelf

      def initialize
        @shelf = nil
      end
    end
  end
end
