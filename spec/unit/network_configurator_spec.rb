# Tongtech.com, Inc.

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::CloudStackCloud::NetworkConfigurator do

  def set_security_groups(spec, security_groups)
    spec["cloud_properties"] = {
      "security_groups" => security_groups
    }
  end

  it "should raise an error if the spec isn't a hash" do
    expect {
      Bosh::CloudStackCloud::NetworkConfigurator.new("foo")
    }.to raise_error ArgumentError
  end

  describe "security groups" do
    it "should be extracted from both dynamic and vip network" do
      spec = {}
      spec["network_a"] = dynamic_network_spec
      set_security_groups(spec["network_a"], %w[foo])
      spec["network_b"] = vip_network_spec
      set_security_groups(spec["network_b"], %w[bar])

      nc = Bosh::CloudStackCloud::NetworkConfigurator.new(spec)
      nc.security_groups(nil).should == %w[bar foo]
    end

    it "should return the default groups if none are extracted" do
      spec = {}
      spec["network_a"] = {"type" => "dynamic"}

      nc = Bosh::CloudStackCloud::NetworkConfigurator.new(spec)
      nc.security_groups(%w[foo]).should == %w[foo]
    end

    it "should return an empty list if no default group is set" do
      spec = {}
      spec["network_a"] = {"type" => "dynamic"}

      nc = Bosh::CloudStackCloud::NetworkConfigurator.new(spec)
      nc.security_groups(nil).should == []
    end

    it "should raise an error when it isn't an array" do
      spec = {}
      spec["network_a"] = dynamic_network_spec
      set_security_groups(spec["network_a"], "foo")

      expect {
        Bosh::CloudStackCloud::NetworkConfigurator.new(spec)
      }.to raise_error ArgumentError, "security groups must be an Array"
    end
  end
end