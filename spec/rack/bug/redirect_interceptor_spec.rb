require 'spec/spec_helper'

describe Rack::Bug::RedirectInterceptor do
  context "redirected when not configured to intercept redirects" do
    it "passes the redirect unmodified" do
      response = get "/redirect"
      response.status.should == 302
    end
    
    it "does not show the interception page" do
      response = get "/redirect"
      response.body.should_not contain("Location: /")
    end

    it "does not insert the toolbar" do
      header 'cookie', ""
      response = get "/redirect"
      response.should_not have_the_toolbar
     end
    
    it "does not insert the toolbar if even toolbar requested" do
      response = get "/redirect"
      response.should_not have_the_toolbar
     end
  end
  
  context "redirected when configured to intercept redirects" do
    it "shows the interception page" do
      response = get "/redirect", {}, "rack-bug.intercept_redirects" => true
      response.should contain("Location: /")
    end
    
    it "inserts the toolbar if requested" do
      response = get "/redirect", {}, "rack-bug.intercept_redirects" => true
      response.should have_the_toolbar
    end
    
    it "does not inserts the toolbar if not requested" do
      header 'cookie', ""
      response = get "/redirect", {}, "rack-bug.intercept_redirects" => true
      response.should_not have_the_toolbar
    end
  end
end