require 'spec/spec_helper'

describe Rack::Bug::LogPanel do
  before do
    @active_panel = Rack::Bug::LogPanel
    @active_panel.reset
  end
  
  it_should_behave_like "active panel"
  
  describe "content" do
    it "displays recorded log lines" do
      get_with_panel.should contain("This is a logged message")
    end

    it "displays log level" do
      get_with_panel.should have_selector("td", :content => ":info")
    end
  end
  
  describe "Extended Logger" do
    it "does still return true/false for #add if class Logger" do
      #AS::BufferedLogger returns the added string, Logger returns true/false
      LOGGER.add(0, "foo").should  == true
    end
  end
  
  
  describe "With no logger defined" do
    it "does not err out" do
      logger = LOGGER
      Object.send :remove_const, :LOGGER
      lambda{ load("rack/bug/panels/log_panel/logger_extension.rb") }.should_not raise_error
      ::LOGGER = logger
    end
  end
end