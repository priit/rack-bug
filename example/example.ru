$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'
require 'rack/bug'

class Example
  def call(env)
    @env = env
    [200, {"Content-Type" => "text/html"}, ["example"]]
  end
end

use Rack::ContentLength
use Rack::Bug
run Example.new