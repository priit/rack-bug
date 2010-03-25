require "rubygems"
require "spec"
require "webrat"
require "rack/test"

$LOAD_PATH.unshift File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift File.dirname(File.dirname(__FILE__))

require 'logger'

module Rails
  def self.version
    ""
  end
  
  def self.logger
    @logger ||= Logger.new(StringIO.new)
  end
  
  class Info
    def self.properties
      []
    end
  end
end

module ActiveRecord
  class Base
  end
end

Rails.logger
require "rack/bug"
require "spec/fixtures/sample_app"
require "spec/fixtures/dummy_panel"

Spec::Runner.configure do |config|
  TIME_MS_REGEXP = /\d+\.\d{2}ms/
  
  config.include Rack::Test::Methods
  config.include Webrat::Matchers
  
  config.before do
    # This allows specs to record data outside the request
    Rack::Bug.enable
    
    # Set the cookie that triggers Rack::Bug under normal conditions
    header 'cookie', "rack_bug_enabled=1"
  end
  
  def app
    Rack::Builder.new do
      use Rack::Bug
      run SampleApp.new
    end
  end
  
  def have_row(container, key, value = nil)
    simple_matcher("contain row") do |response|
      if value
        response.should have_selector("#{container} tr", :content => key) do |row|
          row.should contain(value)
        end
      else
        response.should have_selector("#{container} tr", :content => key)
      end
    end
  end
  
  def have_heading(text)
    simple_matcher("have heading") do |response|
      response.should have_selector("#rack_bug_toolbar li") do |heading|
        heading.should contain(text)
      end
    end
  end
end