# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  before(:each) do
     @registry = mock_registry
   end

  it "deletes an CloudStack server" do
    server = double("server", :id => "i-foobar", :name => "i-foobar", :display_name => "i-foobar")

    cloud = mock_cloud do |cloudstack|
      cloudstack.servers.should_receive(:get).with("i-foobar").and_return(server)
    end

    server.should_receive(:destroy).and_return(true)
    cloud.should_receive(:wait_resource).with(server, :running, :state, true)

    @registry.should_receive(:delete_settings).with("i-foobar")

    cloud.delete_vm("i-foobar")
  end
end
