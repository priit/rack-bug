require "rack/bug/panels/log_panel/logger_extension"

module Rack
  class Bug
    
    class LogPanel < Panel
      
      LEVELS = [:debug, :info, :warn, :error, :fatal, :unknown]
      
      def self.record(message, level)
        return unless Rack::Bug.enabled?
        return unless message
        logs << {:severity => LEVELS[level], :message => message}
      end
      
      def self.reset
        Thread.current["rack.bug.logs"] = []
      end
      
      def self.logs
        Thread.current["rack.bug.logs"] ||= []
      end
      
      def name
        "log"
      end
      
      def heading
        "Log"
      end

      def content
        result = render_template "panels/log", :logs => self.class.logs
        self.class.reset
        return result
      end
      
    end
    
  end
end
