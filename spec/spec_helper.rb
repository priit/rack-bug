require "rubygems"
require "spec"
require "webrat"
require "rack/test"
require 'active_support'

RAILS_ENV = "test"

$LOAD_PATH.unshift File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift File.dirname(File.dirname(__FILE__))

require "rack/bug"
require "spec/fixtures/sample"
require "spec/fixtures/dummy_panel"
require "spec/custom_matchers"
require "spec/shared_examples"

Spec::Runner.configure do |config|
  TIME_MS_REGEXP = /\d+\.\d{2}ms/
  
  config.include Rack::Test::Methods
  config.include Webrat::Matchers
  config.include CustomMatchers
  config.include SharedExamples
  
  config.before do
    # This allows specs to record data outside the request
    Rack::Bug.enable
    
    # Set the cookie that triggers Rack::Bug under normal conditions
    header 'cookie', "rack_bug_enabled=1"
    header "rack-bug.panel_classes", []
  end
  
  config.after do
    remove_rails_if_added
  end
  
  def app
    Sample
  end
  
  def get_with_panel(url = "/", params={}, headers ={})
    get url, params, {"rack-bug.panel_classes" => [@active_panel]}.merge(headers)
  end
  
  def add_rails
    unless defined?(Rails)
      @added_rails = true
      Object.const_set :Rails, Module.new
    end
  end
  
  def remove_rails_if_added
    Object.send :remove_const, :Rails if @added_rails && defined?(Rails)
  end  
end