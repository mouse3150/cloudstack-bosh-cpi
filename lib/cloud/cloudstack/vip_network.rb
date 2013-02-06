# Copyright (c) 2012 Tongtech, Inc.

module Bosh::CloudStackCloud
  ##
  # Represents CloudStack vip network: where users sets VM's IP (floating IP's
  # in CloudStack)
  class VipNetwork < Network

    ##
    # Creates a new vip network
    #
    # @param [String] name Network name
    # @param [Hash] spec Raw network spec
    def initialize(name, spec)
      super
    end

    ##
    # Configures CloudStack vip network
    #
    # @param [Fog::Compute::CloudStack] cloudstack Fog CloudStack Compute client
    # @param [Fog::Compute::CloudStack::Server] server CloudStack server to
    #   configure
    def configure(cloudstack, server)
      if @ip.nil?
        cloud_error("No IP provided for vip network `#{@name}'")
      end

      # Check if the CloudStack floating IP is allocated. If true, disassociate
      # it from any server before associating it to the new server
      address = cloudstack.addresses.find { |a| a.ip == @ip }
      if address
        unless address.instance_id.nil?
          @logger.info("Disassociating floating IP `#{@ip}' " \
                       "from server `#{address.instance_id}'")
          address.server = nil
        end

        @logger.info("Associating server `#{server.id}' " \
                     "with floating IP `#{@ip}'")
        address.server = server
      else
        cloud_error("Floating IP #{@ip} not allocated")
      end
    end

  end
end