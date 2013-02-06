# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  before :each do
    @server = double("server", :id => "i-foobar")

    @cloud = mock_cloud(mock_cloud_options) do |cloudstack|
      cloudstack.servers.stub(:get).with("i-foobar").and_return(@server)
    end
  end

  it "reboots an CloudStack server (CPI call picks soft reboot)" do
    @cloud.should_receive(:soft_reboot).with(@server)
    @cloud.reboot_vm("i-foobar")
  end

  it "soft reboots an CloudStack server" do
    @server.should_receive(:reboot)
    @cloud.should_receive(:wait_resource).with(@server, :running, :state)
    @cloud.send(:soft_reboot, @server)
  end

  it "hard reboots an CloudStack server" do
    @server.should_receive(:reboot)
    @cloud.should_receive(:wait_resource).with(@server, :running, :state)
    @cloud.send(:hard_reboot, @server)
  end

end
