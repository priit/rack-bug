$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'
require 'rack/bug'

class Example
  def call(env)
    @env = env
    [200, {"Content-Type" => "text/html"}, ['<html><body><a href="__rack_bug__/bookmarklet.html">Page with bookmarklet for enabling Rack::Bug</a></body></html>']]
  end
end

use Rack::ContentLength
use Rack::Bug
run Example.new