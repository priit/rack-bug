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

if defined?(Rack::Bug::LoggerClass)
  logger_klass = Rack::Bug::LoggerClass
elsif defined?(ActiveSupport::BufferedLogger)
  logger_klass = ActiveSupport::BufferedLogger
elsif defined?(Logger)
  logger_klass = Logger
end

logger_klass.send :include, LoggingExtensions if logger_klass