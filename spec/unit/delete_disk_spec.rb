# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  it "deletes an CloudStack volume" do
    volume = double("volume", :id => "v-foobar")

    cloud = mock_cloud do |cloudstack|
      cloudstack.volumes.should_receive(:get).
        with("v-foobar").and_return(volume)
    end

    volume.should_receive(:status).and_return(:available)
    volume.should_receive(:destroy).and_return(true)
    cloud.should_receive(:wait_resource).with(volume, :deleted, :status, true)

    cloud.delete_disk("v-foobar")
  end

  it "doesn't delete an CloudStack volume unless it's state is `available'" do
    volume = double("volume", :id => "v-foobar")

    cloud = mock_cloud do |cloudstack|
      cloudstack.volumes.should_receive(:get).with("v-foobar").and_return(volume)
    end

    volume.should_receive(:status).and_return(:busy)

    expect {
      cloud.delete_disk("v-foobar")
    }.to raise_error(Bosh::Clouds::CloudError,
                     "Cannot delete volume `v-foobar', state is busy")
  end

end
