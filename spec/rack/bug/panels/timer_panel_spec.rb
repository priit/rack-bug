require 'spec/spec_helper'

describe Rack::Bug::TimerPanel do
  before do
    @active_panel = Rack::Bug::TimerPanel
    @custom_header = TIME_MS_REGEXP
  end
  
  it_should_behave_like "active panel"

  describe "content" do
    it "displays the user CPU time" do
      get_with_panel.should have_row("#timer", "User CPU time", TIME_MS_REGEXP)
    end
    
    it "displays the system CPU time" do
      get_with_panel.should have_row("#timer", "System CPU time", TIME_MS_REGEXP)
    end
    
    it "displays the total CPU time" do
      get_with_panel.should have_row("#timer", "Total CPU time", TIME_MS_REGEXP)
    end
    
    it "displays the elapsed time" do
      get_with_panel.should have_row("#timer", "Elapsed time", TIME_MS_REGEXP)
    end
  end
end