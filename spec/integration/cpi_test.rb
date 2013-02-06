# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)
require "tempfile"

##
# BOSH CloudStack CPI Integration tests
#
# To run integration test:
# 1. Prepare CloudStack CPI configuration file (a sample can be found at
#    spec/assets/sample_config.yml);
# 2. Set CPI_CONFIG_FILE env variable to point to CloudStack config file;
# 3. Download a public CloudStack stemcell: 'bosh download public stemcell ...';
# 4. Untar the OpenStack stemcell, you'll find and image file;
# 5. Set STEMCELL_FILE env variable to point to OpenStack image file;
# 6. Optional: Set FLOATING_IP env variable with an allocated OpenStack
#    Floating IP if you want to test vip networks;
# 7. Start CloudStack Registry manually (see bosh/openstack_registry);
# 8. Run 'bundle exec rspec --color spec/integration/cpi_test.rb'.
describe Bosh::CloudStackCloud::Cloud do

  before(:each) do
    unless ENV["CPI_CONFIG_FILE"]
      raise "Please provide CPI_CONFIG_FILE environment variable"
    end
    unless ENV["STEMCELL_FILE"]
      raise "Please provide STEMCELL_UUID environment variable"
    end
    @config = YAML.load_file(ENV["CPI_CONFIG_FILE"])
    @logger = Logger.new(STDOUT)
    Bosh::Clouds::Config.stub(:task_checkpoint)
  end

  let(:cpi) do
    cpi = Bosh::CloudStackCloud::Cloud.new(@config)
    cpi.logger = @logger

    # As we inject the configuration file from the outside, we don't care
    # about spinning up the registry ourselves. However we don't want to bother
    # OpenStack at all if registry is not working, so just in case we perform
    # a test health check against whatever has been provided.
    cpi.registry.update_settings("foo", { "bar" => "baz" })
    cpi.registry.read_settings("foo").should == { "bar" => "baz"}
    cpi.registry.delete_settings("foo")

    cpi
  end

  it "exercises a VM lifecycle" do
    unique_name = UUIDTools::UUID.random_create.to_s
    cpi.stub(:generate_unique_name).and_return(unique_name)

    stemcell_id = cpi.create_stemcell(
        ENV["STEMCELL_FILE"],
        {
          "name" => "bosh-stemcell",
          "version" => "0.0.1",
          "infrastructure" => "cloudstack",
          "disk_format" => "VHD",
          "url" => "http://",
          "hypervisor" => "Xenserver",
          "os_type_id" => 126,
         })

    server_id = cpi.create_vm(
      "agent-007", stemcell_id,
      { "instance_type" => "m1.small" },
      { "default" => { "type" => "dynamic" }},
      [], { "key" => "value" })

    server_id.should_not be_nil

    settings = cpi.registry.read_settings("vm-#{unique_name}")
    settings["vm"].should be_a(Hash)
    settings["vm"]["name"].should == "vm-#{unique_name}"
    settings["agent_id"].should == "agent-007"
    settings["networks"].should == { "default" => { "type" => "dynamic" }}
    settings["disks"].should == {
      "system" => "/dev/vda",
      "ephemeral" => "/dev/vdb",
      "persistent" => {}
    }
    settings["env"].should == { "key" => "value" }

    volume_id = cpi.create_disk(1024)
    volume_id.should_not be_nil

    cpi.attach_disk(server_id, volume_id)
    settings = cpi.registry.read_settings("vm-#{unique_name}")
    settings["disks"]["persistent"].should == { volume_id => "/dev/vdc" }

    cpi.reboot_vm(server_id)

    if ENV["FLOATING_IP"]
      cpi.configure_networks(server_id,
                             { "default" => { "type" => "dynamic" },
                               "floating" => { "type" => "vip",
                                               "ip" => ENV["FLOATING_IP"] }
                             })
      settings = cpi.registry.read_settings("vm-#{unique_name}")
      settings["networks"].should == {
        "default" => { "type" => "dynamic" },
        "floating" => { "type" => "vip",
                        "ip" => ENV["FLOATING_IP"] }
      }
    end

    cpi.detach_disk(server_id, volume_id)
    settings = cpi.registry.read_settings("vm-#{unique_name}")
    settings["disks"]["persistent"].should == {}

    cpi.delete_vm(server_id)
    cpi.delete_disk(volume_id)
    cpi.delete_stemcell(stemcell_id)

    expect {
      cpi.registry.read_settings("vm-#{unique_name}")
    }.to raise_error(/HTTP 404/)
  end

end