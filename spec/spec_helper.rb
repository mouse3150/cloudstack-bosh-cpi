# Tongtech.com, Inc.

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "rubygems"
require "bundler"
require "base64"

#Bundler.setup(:default, :test)

require "rspec"
require "tmpdir"

require "cloud/cloudstack"

class CloudStackConfig
  attr_accessor :db, :logger, :uuid
end

cs_config = CloudStackConfig.new
cs_config.db = nil # CloudStack CPI doesn't need DB
cs_config.logger = Logger.new(StringIO.new)
cs_config.logger.level = Logger::DEBUG

Bosh::Clouds::Config.configure(cs_config)

def internal_to(*args, &block)
  example = describe *args, &block
  klass = args[0]
  if klass.is_a? Class
    saved_private_instance_methods = klass.private_instance_methods
    example.before do
      klass.class_eval { public *saved_private_instance_methods }
    end
    example.after do
      klass.class_eval { private *saved_private_instance_methods }
    end
  end
end

def mock_cloud_options
  {
    "cloudstack" => {
      "cloudstack_host" => "168.1.41.4",
      "cloudstack_port" => "8080",
      "cloudstack_api_key" => "api_key",
      "cloudstack_secret_access_key" => "access_key",
      "cloudstack_scheme" => "http",
      "zone_id" => "zoneid",
      "ssh_public_key" => "ssh_pub_key"
    },
    "registry" => {
      "endpoint" => "localhost:42288",
      "user" => "admin",
      "password" => "admin"
    },
    "agent" => {
      "foo" => "bar",
      "baz" => "zaz"
    }
  }
end

def make_cloud(options = nil)
  Bosh::CloudStackCloud::Cloud.new(options || mock_cloud_options)
end

def mock_registry(endpoint = "http://registry:3333")
  registry = mock("registry", :endpoint => endpoint)
  Bosh::CloudStackCloud::RegistryClient.stub!(:new).and_return(registry)
  registry
end

def mock_cloud(options = nil)
  servers = double("servers")
  images = double("images")
  flavors = double("flavors")
  volumes = double("volumes")
  addresses = double("addresses")
  #snapshots = double("snapshots")

  cloudstack = double(Fog::Compute)

  cloudstack.stub(:servers).and_return(servers)
  cloudstack.stub(:images).and_return(images)
  cloudstack.stub(:flavors).and_return(flavors)
  cloudstack.stub(:volumes).and_return(volumes)
  cloudstack.stub(:addresses).and_return(addresses)
  #cloudstack.stub(:snapshots).and_return(snapshots)

  Fog::Compute.stub(:new).and_return(cloudstack)

  yield cloudstack if block_given?

  Bosh::CloudStackCloud::Cloud.new(options || mock_cloud_options)
end

def mock_glance(options = nil)
  images = double("images")

  cloudstack = double(Fog::Compute)
  Fog::Compute.stub(:new).and_return(cloudstack)

  glance = double(Fog::Image)
  glance.stub(:images).and_return(images)

  Fog::Image.stub(:new).and_return(glance)

  yield glance if block_given?

  Bosh::CloudStackCloud::Cloud.new(options || mock_cloud_options)
end


def resource_pool_spec
  {
    "key_name" => "test_key",
    "instance_type" => "Medium Instance"
  }
end

def resource_pool_spec_with_disk
  {
    "disk" => "test_key",
    "instance_type" => "Medium Instance"
  }
end

def dynamic_network_spec
  {
    "type" => "dynamic",
    "cloud_properties" => {
      "security_groups" => %w[default]
    }
  }
end
