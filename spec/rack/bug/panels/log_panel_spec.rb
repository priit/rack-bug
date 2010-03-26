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
  end
end