# Copyright (c) 2012 Tongtech, Inc.

require File.dirname(__FILE__) + "/lib/cloud/cloudstack/version"

Gem::Specification.new do |s|
  s.name         = "bosh_cloudstack_cpi"
  s.version      = Bosh::CloudStackCloud::VERSION
  s.platform     = Gem::Platform::RUBY
  s.summary      = "BOSH CloudStack CPI"
  s.description  = s.summary
  s.author       = "Tongtech .Inc"
  s.email        = "chenhao@tongtech.com"
  s.homepage     = "http://www.tongtech.com"

  #s.files        = `git ls-files -- bin/* lib/*`.split("\n") + %w(README.md Rakefile)
  condidates =Dir.glob("{bin,lib}/**/*") + %w(README.md Rakefile)
  s.files=condidates.delete_if do |item|
    item.include?(".svn") || item.include?(".git")
  end

  #condidates =Dir.glob("{bin,lib,./}/**/*")
  #s.files=condidates.delete_if do |item|
   # item.include?(".svn")|| item.include?(".gem") || item.include?(".git")
  #end
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = "lib"
  s.bindir       = "bin"
  s.executables  = %w(bosh_cloudstack_console)

  s.add_dependency "fog", ">=1.8.0"
  s.add_dependency "bosh_common", ">=0.5.1"
  s.add_dependency "bosh_cpi", ">=0.5.1"
  s.add_dependency "httpclient", ">=2.2.0"
  s.add_dependency "uuidtools", ">=2.1.2"
  s.add_dependency "yajl-ruby", ">=0.8.2"
end
