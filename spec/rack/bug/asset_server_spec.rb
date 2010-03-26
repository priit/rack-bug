require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rack::Bug do
  it "serves the Rack::Bug assets under /__rack_bug_static__/" do
    response = get "/__rack_bug_static__/bug.css"
    response.should be_ok
  end
  
  it "serves the assets directly, even if the toolbar is not enabled" do
    header 'cookie', ""
    response = get "/__rack_bug_static__/bug.css"
    response.should be_ok
    response.should contain('#rack_bug')
  end
  
end