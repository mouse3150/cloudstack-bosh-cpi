# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  it "deletes stemcell by image id" do
    image = double("image", :id => "i-foo", :name => "i-foo",
                   :properties => {})

    cloud = mock_cloud do |cloudstack|
      cloudstack.images.should_receive(:get).with("i-foo").and_return(image)
    end

    image.should_receive(:destroy)

    cloud.delete_stemcell("i-foo")
  end

end
