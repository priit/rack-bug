require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

class Rack::Bug
  describe RailsInfoPanel do
    describe "heading" do
      it "displays the Rails version" do
        Rails.stub!(:version => "v2.3.0")
        response = get "/", {}, {"rack-bug.panel_classes" => [RailsInfoPanel]}
        response.should have_heading("Rails v2.3.0")
      end
    end

    describe "content" do
      it "displays the Rails::Info properties" do
        Rails::Info.stub!(:properties => [["Name", "Value"]])
        response = get "/", {}, {"rack-bug.panel_classes" => [RailsInfoPanel]}
        response.should have_row("#rails_info", "Name", "Value")
      end
    end
  end
end