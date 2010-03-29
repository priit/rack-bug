require 'spec/spec_helper'

describe Rack::Bug::RedirectInterceptor do
  context "redirected when not configured to intercept redirects" do
    subject { get "/redirect" }
        
    it { should_not show_the_interception_page }
    it { should_not have_the_toolbar }
    
    it "passes the redirect unmodified" do
      subject.status.should be(302)
    end
  end
  
  context "redirected when configured to intercept redirects" do
    subject { get "/redirect", {}, "rack-bug.intercept_redirects" => true }
    
    it { should show_the_interception_page }
    it { should have_the_toolbar }
    
    it "does not inserts the toolbar if not requested" do
      header 'cookie', ""
      response = get "/redirect", {}, "rack-bug.intercept_redirects" => true
      response.should_not have_the_toolbar
    end
  end
  
  def show_the_interception_page
    simple_matcher("show the interception page") do |response|
      response.body.include? 'id="rack_bug_toolbar"'
    end
  end
end