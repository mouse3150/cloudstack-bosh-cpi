# Copyright (c) 2012 Piston Cloud Computing, Inc.

module Bosh
  module CloudStackCloud; end
end

require "fog"
require "httpclient"
require "pp"
require "set"
require "tmpdir"
require "uuidtools"
require "yajl"
require "base64"

require "common/thread_pool"
require "common/thread_formatter"

require "cloud"
require "cloud/cloudstack/helpers"
require "cloud/cloudstack/cloud"
require "cloud/cloudstack/registry_client"
require "cloud/cloudstack/version"

require "cloud/cloudstack/network_configurator"
require "cloud/cloudstack/network"
require "cloud/cloudstack/dynamic_network"
require "cloud/cloudstack/vip_network"

module Bosh
  module Clouds
    CloudStack = Bosh::CloudStackCloud::Cloud
    Cloudstack = CloudStack # Alias needed for Bosh::Clouds::Provider.create method
  end
end
