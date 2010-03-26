require "rack"
require "ipaddr"
require "digest"

class Rack::Bug
  autoload :Options,                "rack/bug/options"
  autoload :Panel,                  "rack/bug/panel"
  autoload :PanelApp,               "rack/bug/panel_app"
  autoload :ParamsSignature,        "rack/bug/params_signature"
  autoload :RedirectInterceptor,     "rack/bug/redirect_interceptor"
  autoload :Render,                 "rack/bug/render"
  autoload :Toolbar,                "rack/bug/toolbar"

  # Panels
  autoload :ActiveRecordPanel,      "rack/bug/panels/active_record_panel"
  autoload :CachePanel,             "rack/bug/panels/cache_panel"
  autoload :LogPanel,               "rack/bug/panels/log_panel"
  autoload :MemoryPanel,            "rack/bug/panels/memory_panel"
  autoload :RailsInfoPanel,         "rack/bug/panels/rails_info_panel"
  autoload :RedisPanel,             "rack/bug/panels/redis_panel"
  autoload :RequestVariablesPanel,  "rack/bug/panels/request_variables_panel"
  autoload :SQLPanel,               "rack/bug/panels/sql_panel"
  autoload :TemplatesPanel,         "rack/bug/panels/templates_panel"
  autoload :TimerPanel,             "rack/bug/panels/timer_panel"

  VERSION = "0.2.2.pre"

  include Options

  class SecurityError < StandardError
  end

  def self.enable
    Thread.current["rack-bug.enabled"] = true
  end

  def self.disable
    Thread.current["rack-bug.enabled"] = false
  end

  def self.enabled?
    Thread.current["rack-bug.enabled"] == true
  end

  def self.asset_server(app)
    Rack::Static.new(app, :urls => ["/__rack_bug_static__"], 
      :root => ::File.expand_path(::File.dirname(__FILE__) + "/bug/public"))
  end

  def initialize(app, options = {}, &block)
    @app = self.class.asset_server(app)
    initialize_options options
    instance_eval(&block) if block_given?
    
    @toolbar = Toolbar.new(RedirectInterceptor.new(@app))
  end
  
  def call(env)
    @original_request = Rack::Request.new(env)
    env.replace @default_options.merge(env)
    @env = env
    
    if toolbar_requested? && ip_authorized? && password_authorized?
      @toolbar.call(@env)
    else
      @app.call(@env)
    end
  end
  
  def toolbar_requested?
    @original_request.cookies["rack_bug_enabled"]
  end
  
  def ip_authorized?
    return true unless options["rack-bug.ip_masks"]
    
    options["rack-bug.ip_masks"].any? do |ip_mask|
      ip_mask.include?(IPAddr.new(@original_request.ip))
    end
  end
  
  def password_authorized?
    return true unless options["rack-bug.password"]
    
    expected_sha = Digest::SHA1.hexdigest ["rack_bug", options["rack-bug.password"]].join(":")
    actual_sha = @original_request.cookies["rack_bug_password"]
    
    actual_sha == expected_sha
  end
end