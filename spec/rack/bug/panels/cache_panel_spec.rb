require 'spec/spec_helper'

describe Rack::Bug::CachePanel do
  
  before do
    @active_panel = Rack::Bug::CachePanel
    @active_panel.reset
    unless defined?(Rails)
      @added_rails = true
      Object.const_set :Rails, Module.new
    end
    
    @custom_header = "Cache: 0.00ms (0 calls)"
  end
  
  it_should_behave_like "active panel"
  
  describe "heading" do
    it "displays the total memcache time" do
      get_with_panel.should have_heading("Cache: 0.00ms")
    end
  end
  
  describe "content" do
    describe "usage table" do
      it "displays the total number of memcache calls" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "Total Calls", "1")
      end
      
      it "displays the total memcache time" do
        get_with_panel.should have_row("#cache_usage", "Total Time", "0.00ms")
      end
      
      it "dispays the number of memcache hits" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "Hits", "0")
      end
      
      it "displays the number of memcache misses" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "Misses", "1")
      end
      
      it "displays the number of memcache gets" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "gets", "1")
      end
      
      it "displays the number of memcache sets" do
        @active_panel.record(:set, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "sets", "1")
      end
      
      it "displays the number of memcache deletes" do
        @active_panel.record(:delete, "user:1") { }
        get_with_panel.should have_row("#cache_usage", "deletes", "1")
      end
      
      it "displays the number of memcache get_multis" do
        @active_panel.record(:get_multi, "user:1", "user:2") { }
        get_with_panel.should have_row("#cache_usage", "get_multis", "1")
      end
    end
    
    describe "breakdown" do
      it "displays each memcache operation" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_breakdown", "get")
      end
      
      it "displays the time for each memcache call" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_breakdown", "user:1", TIME_MS_REGEXP)
      end
      
      it "displays the keys for each memcache call" do
        @active_panel.record(:get, "user:1") { }
        get_with_panel.should have_row("#cache_breakdown", "user:1", "get")
      end
    end
  end
  
  describe "expire_all" do
    it "expires the cache keys" do
      Rails.stub!(:cache => mock("cache"))
      Rails.cache.should_receive(:delete).with("user:1")
      Rails.cache.should_receive(:delete).with("user:2")
      Rails.cache.should_receive(:delete).with("user:3")
      Rails.cache.should_receive(:delete).with("user:4")
      
      get "/__rack_bug__/delete_cache_list",
        {:keys_1 => "user:1", :keys_2 => "user:2", :keys_3 => "user:3", :keys_4 => "user:4",
        :hash => "c367b76e0199c308862a3afd8fba32b8715e7976"}, 
        {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
        
    end
    
    it "returns OK" do
      Rails.stub!(:cache => mock("cache", :delete => nil))
      response = get "/__rack_bug__/delete_cache_list",
        {:keys_1 => "user:1", :keys_2 => "user:2", :keys_3 => "user:3", :keys_4 => "user:4",
        :hash => "c367b76e0199c308862a3afd8fba32b8715e7976"}, 
        {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
      response.should contain("OK")
    end
  end
  
  describe "expire" do
    it "expires the cache key" do
      Rails.stub!(:cache => mock("cache"))
      Rails.cache.should_receive(:delete).with("user:1")
      get "/__rack_bug__/delete_cache", {:key => "user:1",
        :hash => "f87215442d312d8e42cf51e6b66fc3eb3d59ac74"},
        {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
    end
    
    it "returns OK" do
      Rails.stub!(:cache => mock("cache", :delete => nil))
      response = get "/__rack_bug__/delete_cache", {:key => "user:1",
        :hash => "f87215442d312d8e42cf51e6b66fc3eb3d59ac74"},
        {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
      response.should contain("OK")
    end
  end
  
  describe "view_cache" do
    it "renders the cache key" do
      Rails.stub!(:cache => mock("cache", :read => "cache body"))
      response = get "/__rack_bug__/view_cache", {:key => "user:1",
        :hash => "f87215442d312d8e42cf51e6b66fc3eb3d59ac74"},
         {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
      response.should contain("cache body")
    end
    
    it "renders non-String cache values properly" do
      Rails.stub!(:cache => mock("cache", :read => [1, 2]))
      response = get "/__rack_bug__/view_cache", {:key => "user:1",
        :hash => "f87215442d312d8e42cf51e6b66fc3eb3d59ac74"}, 
        {"rack-bug.panel_classes" => [@active_panel], "rack-bug.secret_key" => 'abc'}
      response.should contain("[1, 2]")
    end
  end
end