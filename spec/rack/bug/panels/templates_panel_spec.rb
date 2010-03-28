require 'spec/spec_helper'

describe Rack::Bug::TemplatesPanel do
  before do
    @active_panel = Rack::Bug::TemplatesPanel
    @active_panel.reset
    @custom_header = "Templates: 0.00ms"
  end
  
  it_should_behave_like "active panel"
  
  describe "content" do
    it "displays the template paths" do
      @active_panel.record("users/show") { }
      get_with_panel.should contain("users/show")
    end
    
    it "displays the template children" do
      @active_panel.record("users/show") do
        @active_panel.record("users/toolbar") { }
      end
      
      get_with_panel.should have_selector("li", :content => "users/show") do |li|
        li.should contain("users/toolbar")
      end
    end
    
    context "for templates that rendered templates" do
      it "displays the total time" do
        @active_panel.record("users/show") do
          @active_panel.record("users/toolbar") { }
        end
        
        get_with_panel.should have_selector("li", :content => "users/show") do |li|
          li.should contain(TIME_MS_REGEXP)
        end
      end
      
      it "displays the exclusive time" do
        @active_panel.record("users/show") do
          @active_panel.record("users/toolbar") { }
        end
        
        get_with_panel.should have_selector("li", :content => "users/show") do |li|
          li.should contain(/\d\.\d{2} exclusive/)
        end
      end
    end
    
    context "for leaf templates" do
      it "does not display the exclusive time" do
        @active_panel.record("users/show") { }
        
        get_with_panel.should contain("users/show") do |li|
          li.should_not contain("exclusive")
        end
      end
    end
  end
end