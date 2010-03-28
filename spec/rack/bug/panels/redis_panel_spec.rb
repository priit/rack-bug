require 'spec/spec_helper'
$LOADED_FEATURES << "redis.rb" #avoid dependency on redis

describe Rack::Bug::RedisPanel do
  before do
    @active_panel = Rack::Bug::RedisPanel
    @custom_header = "Redis: 0.00ms"
    @active_panel.reset
  end
  
  it_should_behave_like "active panel"

  describe "usage table" do
    it "displays the total number of redis calls" do
      @active_panel.record(["get, user:1"]) { }
      get_with_panel.should have_row("#redis_usage", "Total Calls", "1")
    end
    
    it "displays the total redis time" do
      get_with_panel.should have_row("#redis_usage", "Total Time", "0.00ms")
    end
  end
  
  describe "breakdown" do
    it "displays each redis operation" do
      @active_panel.record(["get, user:1"]) { }
      get_with_panel.should have_row("#redis_breakdown", "get")
    end
    
    it "displays the time for redis call" do
      @active_panel.record(["get, user:1"]) { }
      get_with_panel.should have_row("#redis_breakdown", "user:1", TIME_MS_REGEXP)
    end
    
    it "displays the arguments for each redis call" do
      @active_panel.record(["get, user:1"]) { }
      get_with_panel.should have_row("#redis_breakdown", "user:1", "get")
    end
  end
end