require 'spec/spec_helper'

describe Rack::Bug::Security do
  context "configured with require_ssl" do
    it "does not insert the toolbar if plain http" do
      get("/",{},"rack-bug.require_ssl" => true).should_not have_the_toolbar
    end
    
    it "inserts the toolbar when the rack.url_scheme is https" do
      response = get "/", {}, "rack.url_scheme" => "https", 
        "rack-bug.require_ssl" => true
      response.should have_the_toolbar
    end
    
    it "inserts the toolbar when proxy request was ssl" do
      response = get "/", {}, "HTTP_X_FORWARDED_PROTO" => "https", 
        "rack-bug.require_ssl" => true
      response.should have_the_toolbar
    end
    
    it "inserts the toolbar when the request was HTTPS is on" do
      response = get "/", {}, "HTTPS" => "on", 
        "rack-bug.require_ssl" => true
      response.should have_the_toolbar
    end
  end
  
  context "configured with an IP address restriction" do
    it "inserts the toolbar when the IP matches" do
      response = get "/", {}, "REMOTE_ADDR" => "127.0.0.2", 
        "rack-bug.ip_masks" => [IPAddr.new("127.0.0.1/255.255.255.0")]
      response.should have_the_toolbar
    end
    
    it "is disabled when the IP doesn't match" do
      response = get "/", {}, "REMOTE_ADDR" => "128.0.0.1",
        "rack-bug.ip_masks" => [IPAddr.new("127.0.0.1/255.255.255.0")]
      response.should_not have_the_toolbar
    end
    
    it "doesn't use any panels" do
      DummyPanel.should_not_receive(:new)
      get "/", {}, "REMOTE_ADDR" => "128.0.0.1",
        "rack-bug.ip_masks" => [IPAddr.new("127.0.0.1/255.255.255.0")],
        "rack-bug.panel_classes" => [DummyPanel]
    end
  end
  
  context "configured with a password" do
    it "inserts the toolbar when the password matches" do
      sha = "545049d1c5e2a6e0dfefd37f9a9e0beb95241935"
      header 'cookie', "rack_bug_enabled=1;rack_bug_password=#{sha}"
      response = get "/", {}, "rack-bug.password" => "secret"
      response.should have_the_toolbar
    end
    
    it "is disabled when the password doesn't match" do
      response = get "/", {}, "rack-bug.password" => "secret"
      response.should_not have_the_toolbar
    end
    
    it "doesn't use any panels" do
      DummyPanel.should_not_receive(:new)
      get "/", {}, "rack-bug.password" => "secret", "rack-bug.panel_classes" => [DummyPanel]
    end
  end
end