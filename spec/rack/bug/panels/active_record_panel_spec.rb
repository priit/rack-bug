require 'spec/spec_helper'

describe Rack::Bug::ActiveRecordPanel do
  before do
    @active_panel = Rack::Bug::ActiveRecordPanel
    
    @active_panel.reset
    @custom_header = "0 AR Objects"
  end
  
  it_should_behave_like "active panel"
  
  describe "heading" do
    it "displays the total number of instantiated AR objects" do
      @active_panel.record("User")
      @active_panel.record("Group")
      get_with_panel.should have_heading("2 AR Objects")
    end
  end
  
  describe "content" do
    it "displays the count of instantiated objects for each class" do
      @active_panel.record("User")
      @active_panel.record("User")
      @active_panel.record("Group")
      response = get_with_panel
      response.should have_row("#active_record", "User", "2")
      response.should have_row("#active_record", "Group", "1")
    end
  end
end