if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger
  module Rack::Bug::LoggerExtension
    def add(*args, &block)
      super
      logged_message = args[2]
      Rack::Bug::LogPanel.record(logged_message, args[0])
      return logged_message
    end
  end

  Rails.logger.extend Rack::Bug::LoggerExtension
end