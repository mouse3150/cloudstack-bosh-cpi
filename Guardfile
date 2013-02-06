# Copyright (c) Tongtech, Inc.

guard :bundler, :notify => false do
  watch("Gemfile")
end

group :unit_tests do
  guard :rspec, :cli => "--color --format nested --fail-fast -p",
                :all_after_pass => false, :spec_paths => %w(spec/unit) do
    watch("spec/spec_helper.rb")             { "spec/unit" }
    watch("cloudstack.rb")                    { "spec/unit" }
    watch(%r{^spec/unit/.+_spec\.rb})
    watch(%r{^lib/cloud/cloudstack/(.+)\.rb}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  end
end

guard :yard, :stdout => "/dev/null", :stderr => "/dev/null" do
  watch("README.md")
  watch(%r{lib/cloud/cloudstack/.+\.rb})
end
