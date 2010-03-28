require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

class Rack::Bug
  describe RailsInfoPanel do
    before do
      @active_panel = RailsInfoPanel
    end
    
    describe "when Rails is undefined" do
      it_should_behave_like "active toolbar"
      
      it "does not load RailsInfo" do
        response = get "/", {}, {"rack-bug.panel_classes" => [@active_panel]}
        response.should_not have_panel("rails_info")
      end
    end

    
    describe "when Rails is defined" do 
      before do
        add_rails
      end
      
      describe "and Rails::Info is undefined, such as in production" do
        it_should_behave_like "active toolbar"
        
        it "does not load RailsInfo" do
          response = get "/", {}, {"rack-bug.panel_classes" => [@active_panel]}
          response.should_not have_panel("rails_info")
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
          
        end
      
        after do
          Rails.send :remove_const, :Info
        end
      
        it_should_behave_like "active panel"
      
        it "displays the Rails version in the heading" do         
          response = get "/", {}, {"rack-bug.panel_classes" => [@active_panel]}
          response.should have_heading("Rails v2.3.0")
        end

        it "displays the Rails::Info specific row" do
          response = get "/", {}, {"rack-bug.panel_classes" => [@active_panel]}
          response.should have_row("#rails_info", "Name", "Value")
        end
      end
    end
  end
end