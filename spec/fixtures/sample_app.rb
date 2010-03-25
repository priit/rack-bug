require "sinatra/base"
require 'logger'
unless defined?(Rails)
  module Rails
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end

class SampleApp < Sinatra::Base

  get "/redirect" do
    redirect "/"
  end
  
  get "/error" do
    raise "Error!"
  end
  
  get "/" do
    Rails.logger.info "This is a logged message"
    if params[:content_type]
      headers["Content-Type"] = params[:content_type]
    end
    
    <<-HTML
      <html>
        <head>
        </head>
        <body>
          <p>Hello</p>
          <p><a href="__rack_bug__/bookmarklet.html">Page with bookmarklet for enabling Rack::Bug</a></p>
        </body>
      </html>
    HTML
  end
  
end