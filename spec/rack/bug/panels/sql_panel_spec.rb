require 'spec/spec_helper'

describe Rack::Bug::SQLPanel do
  before do
    @active_panel = Rack::Bug::SQLPanel
    @active_panel.reset
    @custom_header = "0 Queries (0.00ms)"
    unless defined?(ActiveRecord)
      @added_rails = true
      Object.const_set :ActiveRecord, Module.new
      ActiveRecord.const_set :Base, Class.new
    end
  end
  
  after do
    Object.send :remove_const, :ActiveRecord if @added_active_record
  end
  
  it_should_behave_like "active panel"
  
  describe "heading" do
    it "displays the total SQL query count" do
      @active_panel.record("SELECT NOW();") { }
      get_with_panel.should have_heading("1 Queries")
    end
    
    it "displays the total SQL time" do
      @active_panel.record("SELECT NOW();") { }
      get_with_panel.should have_heading(/Queries \(\d+\.\d{2}ms\)/)
    end
  end
  
  describe "content" do
    it "displays each executed SQL query" do
      @active_panel.record("SELECT NOW();") { }
      get_with_panel.should have_row("#sql", "SELECT NOW();")
    end
    
    it "displays the time of each executed SQL query" do
      @active_panel.record("SELECT NOW();") { }
      get_with_panel.should have_row("#sql", "SELECT NOW();", TIME_MS_REGEXP)
    end
  end
  
  def stub_result(results = [[]])
    columns = results.first
    fields = columns.map { |c| stub("field", :name => c) }
    rows = results[1..-1]
    
    result = stub("result", :fetch_fields => fields)
    result.stub!(:each).and_yield(*rows)
    return result
  end
  
  def expect_query(sql, results)
    conn = stub("connection")
    ActiveRecord::Base.stub!(:connection => conn)
    conn.should_receive(:execute).with(sql).and_return(stub_result(results))
  end
  
  describe "execute_sql" do
    it "displays the query results" do
      expect_query "SELECT username FROM users",
        [["username"],
         ["bryan"]]
      
      response = get "/__rack_bug__/execute_sql", {:query => "SELECT username FROM users",
        :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => "abc"}
      response.should contain("SELECT username FROM users")
      response.should be_ok
    end
    
    it "is forbidden when the hash is missing or wrong" do        
      lambda {
        get "/__rack_bug__/execute_sql", {:query => "SELECT username FROM users",
          :hash => "foobar"}, {"rack-bug.secret_key" => "abc"}
      }.should raise_error(Rack::Bug::SecurityError)
    end
    
    it "is not available when the rack-bug.secret_key is nil" do
      lambda {
        get "/__rack_bug__/execute_sql", {:query => "SELECT username FROM users",
          :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => nil}
      }.should raise_error(Rack::Bug::SecurityError)
    end
    
    it "is not available when the rack-bug.secret_key is an empty string" do        
      lambda {
        get "/__rack_bug__/execute_sql", {:query => "SELECT username FROM users",
          :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => nil}
      }.should raise_error(Rack::Bug::SecurityError)
    end
  end
  
  describe "explain_sql" do
    it "displays the query explain plan" do
      expect_query "EXPLAIN SELECT username FROM users",
        [["table"],
         ["users"]]
      
      response = get "/__rack_bug__/explain_sql", {:query => "SELECT username FROM users",
        :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => "abc"}
      response.should contain("SELECT username FROM users")
      response.should be_ok
    end
    
    it "is forbidden when the hash is missing or wrong" do        
      lambda {
        get "/__rack_bug__/explain_sql", {:query => "SELECT username FROM users",
          :hash => "foobar"}, {"rack-bug.secret_key" => "abc"}
      }.should raise_error(Rack::Bug::SecurityError)
    end
    
    it "is not available when the rack-bug.secret_key is nil" do
      lambda {
        get "/__rack_bug__/explain_sql", {:query => "SELECT username FROM users",
          :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => nil}
      }.should raise_error(Rack::Bug::SecurityError)
    end
    
    it "is not available when the rack-bug.secret_key is an empty string" do
      lambda {
        get "/__rack_bug__/explain_sql", {:query => "SELECT username FROM users",
          :hash => "6f286f55b75716e5c91f16d77d09fa73b353ebc1"}, {"rack-bug.secret_key" => ""}
      }.should raise_error(Rack::Bug::SecurityError)
    end
  end
end