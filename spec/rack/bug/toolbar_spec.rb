require 'spec/spec_helper'

describe Rack::Bug do  
  it_should_behave_like "active toolbar"
  
  it "updates the Content-Length" do
    response = get "/"
    response["Content-Length"].should == response.body.size.to_s
  end
  
  it "modifies HTML responses with a charset" do
    response = get "/", :content_type => "application/xhtml+xml; charset=utf-8"
    response.should have_the_toolbar
  end
  
  it "does not modify XMLHttpRequest responses" do
    response = get "/", {}, { :xhr => true }
    response.should_not have_the_toolbar
  end
  
  it "modifies XHTML responses" do
    response = get "/", :content_type => "application/xhtml+xml"
    response.should have_the_toolbar
  end
  
  it "does not modify non-HTML responses" do
    response = get "/", :content_type => "text/csv"
    response.should_not have_the_toolbar
  end
  
  it "does not modify server errors" do
    app.disable :raise_errors
    response = get "/error"
    app.enable :raise_errors
    response.should_not have_the_toolbar
  end
  
  it "modify <body>less pages" do
    response = get "/bodiless"
    response.should have_the_toolbar
  end
  
end