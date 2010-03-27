require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

class Rack::Bug
  describe LogPanel do
    before do
      LogPanel.reset
    end
    
    describe "heading" do
      it "displays 'Log'" do
        response = get "/", {}, {"rack-bug.panel_classes" => [LogPanel]}
        response.should have_heading("Log")
      end
    end
    
    describe "content" do
      it "displays recorded log lines" do
        response = get "/"
        response.should contain("This is a logged message")
      end

      it "displays log level" do
        response = get "/"
        response.should have_selector("td", :content => ":info")
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
        Object.send :remove_const, :LOGGER
        lambda{ load("rack/bug/panels/log_panel/logger_extension.rb") }.should_not raise_error
      end
    end
  end
end