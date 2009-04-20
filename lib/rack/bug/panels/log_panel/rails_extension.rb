if defined?(Rails) #&& Rails.logger
  module LoggingExtensions
    def self.included(target)
      target.alias_method_chain :add, :rack_bug
    end
    
    def add_with_rack_bug(*args, &block)
      logged_message = add_without_rack_bug(*args, &block)
      Rack::Bug::LogPanel.record(*args)
      return logged_message
    end
  end

  ActiveSupport::BufferedLogger.send :include, LoggingExtensions
end