require 'spec/spec_helper'

describe Rack::Bug::RailsInfoPanel do
  before do
    @active_panel = Rack::Bug::RailsInfoPanel
  end
  
  describe "when Rails is undefined" do
    it_should_behave_like "active toolbar"
    
    it "does not load RailsInfo" do
      get_with_panel.should_not have_panel("rails_info")
    end
  end

  
  describe "when Rails is defined" do 
    before do
      add_rails
    end
    
    describe "and Rails::Info is undefined, such as in production" do
      it_should_behave_like "active toolbar"
      
      it "does not load RailsInfo" do
        get_with_panel.should_not have_panel("rails_info")
      end
    end
    
    describe "and Rails::Info is defined" do
      before do
        Rails::Info = Class.new do
          def self.properties
            [["Name", "Value"]]
          end
        end
        Rails.stub!(:version => "v2.3.0")
        @custom_header = "Rails v2.3.0"
      end
    
      it_should_behave_like "active toolbar"
      it_should_behave_like "active panel"
    
      it "displays the Rails::Info specific row" do
        get_with_panel.should have_row("#rails_info", "Name", "Value")
      end
    end
  end
end