# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::Cloud do

  before :each do
    @zone_id = "zone_id"
  end

  describe "Image register based url resource" do

    it "creates stemcell using an image" do
      image = double("image", :id => "i-bar", :name => "i-bar")
      unique_name = UUIDTools::UUID.random_create.to_s
      image_params = {
        :name => "BOSH-#{unique_name}",
        :display_text => "display-name",
        :format => "VHD",
        :url => "http://10.0.0.1/stemcell.bz2",
        :hypervisor => "XenServer",
        :os_type_id => 126,
        :zone_id => "zoneid"
      }

      cloud = mock_cloud do |cloudstack|
        cloudstack.images.should_receive(:create).
          with(image_params).and_return(image)
      end

      #Dir.should_receive(:mktmpdir).and_yield(@tmp_dir)
      #cloud.should_receive(:unpack_image).with(@tmp_dir, "/tmp/foo")
      #cloud.should_receive(:generate_unique_name).and_return(unique_name)
      
      cloud.should_receive(:wait_resource).with(image, :true, :is_ready)

      sc_id = cloud.create_stemcell("/tmp/foo", {
        "name" => "BOSH-#{unique_name}",
        "hypervisor" => "XenServer",
        "format" => "VHD",
        'ostypeid' => 126,
        'displaytext' => "display-name",
        'url' => "http://10.0.0.1/stemcell.bz2",
      })

      sc_id.should == "i-bar"
    end

  end

end
