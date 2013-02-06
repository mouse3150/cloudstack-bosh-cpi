# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  describe "creating via provider" do

    it "can be created using Bosh::Cloud::Provider" do
      Fog::Compute.stub(:new)
      Fog::Image.stub(:new)
      cloud = Bosh::Clouds::Provider.create(:cloudstack, mock_cloud_options)
      cloud.should be_an_instance_of(Bosh::CloudStackCloud::Cloud)
    end

  end

end
