require 'vagrant/errors'

module VagrantPlugins
  module Berkshelf
    INSTALL_CHEFDK_INSTRUCTIONS = <<-EOH.freeze
Please download and install the latest version of the ChefDK from:

    https://downloads.chef.io/chef-dk

and follow the installation instructions. Do not forget to add the ChefDK to
your PATH.
EOH

    class BerkshelfNotFound < Vagrant::Errors::VagrantError
      def error_message
        <<-EOH
Vagrant Berkshelf could not find the 'berks' executable in your PATH.

#{INSTALL_CHEFDK_INSTRUCTIONS}
EOH
      end
    end

    class BerksCommandFailed < Vagrant::Errors::VagrantError
      def initialize(command, stdout, stderr)
        @command, @stdout, @stderr = command, stdout, stderr
        super
      end

      def chefdk?
        @command.include?("chefdk")
      end

      def not_chefdk_message
        <<-EOH
It appears that you are not using the ChefDK. Please note that Vagrant Berkshelf
works best when used with the ChefDK, and other installation methods are not
officially supported.

#{INSTALL_CHEFDK_INSTRUCTIONS}
EOH
      end

      def error_message
        base = <<-EOH
The following berks command failed to execute:

    #{@command}

The stdout and stderr are shown below:

    stdout: #{@stdout}
    stderr: #{@stderr}
EOH

        base << "\n#{not_chefdk_message}" if !chefdk?
        base
      end
    end

    class InvalidBerkshelfVersionError < Vagrant::Errors::VagrantError
      def initialize(bin, constraint, version)
        @bin        = bin
        @constraint = constraint
        @version    = version
        super
      end

      def error_message
        <<-EOH
The Berkshelf version at #{@bin.inspect} is invalid.
Vagrant Berkshelf requires #{@constraint}, but the current version is #{@version}.

#{INSTALL_CHEFDK_INSTRUCTIONS}
EOH
      end
    end
  end
end
