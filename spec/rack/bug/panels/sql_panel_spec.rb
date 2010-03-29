require 'spec/spec_helper'

describe Rack::Bug::SQLPanel do
  before do
    @active_panel = Rack::Bug::SQLPanel
    @active_panel.reset
    @custom_header = "1 Queries"
    unless defined?(ActiveRecord)
      @added_rails = true
      Object.const_set :ActiveRecord, Module.new
      ActiveRecord.const_set :Base, Class.new
    end
    @active_panel.record("SELECT NOW();") { }
  end
  
  after do
    Object.send :remove_const, :ActiveRecord if @added_active_record
  end
  
  it_should_behave_like "active panel"
  
  describe "normal (safe) content" do
    subject { get_with_panel }
    
    describe "heading" do
      it "displays the total SQL query count" do
        should have_heading("1 Queries")
      end
    
      it "displays the total SQL time" do
        should have_heading(/Queries \(\d+\.\d{2}ms\)/)
      end
    end
  
    describe "content" do
      it "displays each executed SQL query" do
        should have_row("#sql", "SELECT NOW();")
      end
    
      it "displays the time of each executed SQL query" do
        should have_row("#sql", "SELECT NOW();", TIME_MS_REGEXP)
      end
    end
  end
  
  
  describe "execute_sql" do
    it "displays the query results" do
      expect_query "SELECT username FROM users",
        [["username"],
         ["bryan"]]
      
      rack_bug_request("execute_sql").should contain("SELECT username FROM users")
    end
    
    it "is forbidden when the hash is missing or wrong" do        
      rack_bug_request_should_be_error "execute_sql", :hash => "foobar"
    end
    
    it "is not available when the rack-bug.secret_key is nil" do
      rack_bug_request_should_be_error "execute_sql", :secret_key => nil
    end
    
    it "is not available when the rack-bug.secret_key is an empty string" do
      rack_bug_request_should_be_error "execute_sql", :secret_key => ""
    end
  end
  
  describe "explain_sql" do
    it "displays the query explain plan" do
      expect_query "EXPLAIN SELECT username FROM users",
        [["table"],
         ["users"]]
      
      rack_bug_request("explain_sql").should contain("SELECT username FROM users")
    end
    
    it "is forbidden when the hash is missing or wrong" do        
      rack_bug_request_should_be_error "explain_sql", :hash => "foobar"
    end
    
    it "is not available when the rack-bug.secret_key is nil" do
      rack_bug_request_should_be_error "explain_sql", :secret_key => nil
    end
    
    it "is not available when the rack-bug.secret_key is an empty string" do
      rack_bug_request_should_be_error "explain_sql", :secret_key => ""
    end
  end
  
  def rack_bug_request_should_be_error(action, options={})
    lambda {
      rack_bug_request action, options
    }.should raise_error(Rack::Bug::SecurityError)
    
  end
  
  def rack_bug_request(action, options={})
    hash = options.has_key?(:hash) ? options[:hash] : "6f286f55b75716e5c91f16d77d09fa73b353ebc1"
    secret_key = options.has_key?(:secret_key) ? options[:secret_key] : "abc"
    get "/__rack_bug__/#{action}", {:query => "SELECT username FROM users",
      :hash => hash}, {"rack-bug.secret_key" => secret_key}
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
end