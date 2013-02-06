# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  it "doesn't implement `validate_deployment'" do
    Fog::Compute.stub(:new)
    Fog::Image.stub(:new)
    cloud = make_cloud
    expect {
      cloud.validate_deployment({}, {})
    }.to raise_error(Bosh::Clouds::NotImplemented,
      "`validate_deployment' is not implemented by Bosh::CloudStackCloud::Cloud")
  end

end
