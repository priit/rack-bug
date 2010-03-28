module Rack
  class Bug
    
    class RailsInfoPanel < Panel
      
      def name
        "rails_info"
      end
      
      def heading
        return unless (defined?(Rails) && defined?(Rails::Info))
        "Rails #{Rails.version}"
      end

      def content
        return unless (defined?(Rails) && defined?(Rails::Info))
        @content ||= render_template "panels/rails_info"
      end
      
      def has_content?
        !!content
      end
      
    end
    
  end
end
