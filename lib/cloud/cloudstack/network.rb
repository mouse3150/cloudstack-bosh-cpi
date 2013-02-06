# Copyright (c) 2012 Tongtech, Inc.

module Bosh::CloudStackCloud
  ##
  # Represents CloudStack network.
  class Network
    include Helpers

    ##
    # Creates a new network
    #
    # @param [String] name Network name
    # @param [Hash] spec Raw network spec
    def initialize(name, spec)
      unless spec.is_a?(Hash)
        raise ArgumentError, "Invalid spec, Hash expected, " \
                             "#{spec.class} provided"
      end

      @logger = Bosh::Clouds::Config.logger

      @name = name
      @ip = spec["ip"]
      @cloud_properties = spec["cloud_properties"]
    end

    ##
    # Configures given server
    #
    # @param [Fog::Compute::CloudStack] cloudstack Fog CloudStack Compute client
    # @param [Fog::Compute::CloudStack::Server] server CloudStack server to configure
    def configure(cloudstack, server)
      cloud_error("`configure' not implemented by #{self.class}")
    end

  end
end