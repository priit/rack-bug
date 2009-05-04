require "rubygems"

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
require "rack/bug"

require "sinatra/base"
require 'logger'
RAILS_ENV ||= "development"
log_to = RAILS_ENV == "test" ? StringIO.new : STDOUT
LOGGER = Logger.new(log_to)

class Sample < Sinatra::Base
  use Rack::Bug
  set :environment, 'test'
  
  configure :test do
    set :raise_errors, true
  end
  
  get "/bodiless" do
    <<-HTML
      <p>Hello</p>
    HTML
  end
  
  get "/redirect" do
    redirect "/"
  end
  
  get "/error" do
    raise "Error!"
  end
  
  get "/" do
    LOGGER.info "This is a logged message"
    if params[:content_type]
      headers["Content-Type"] = params[:content_type]
    end
    
    <<-HTML
      <html>
        <head>
        </head>
        <body>
          <p>Hello</p>
          <p><a href="__rack_bug_static__/bookmarklet.html">Page with bookmarklet for enabling Rack::Bug</a></p>
        </body>
      </html>
    HTML
  end
  
end