require "rack/bug/panels/log_panel/logger_extension"

module Rack
  module Bug
    
    class LogPanel < Panel
            
      def self.record(message, severity)
        return unless Rack::Bug.enabled?
        @start_time ||= Time.now
        logs << {:level => severity, :message => message, :time => ((Time.now - @start_time) * 1000).to_i}
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
