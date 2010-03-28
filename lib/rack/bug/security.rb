module Rack
  class Bug
    module Security

      def safe_to_call_toolbar?
        ip_authorized? && password_authorized? && ssl_authorized?
      end
      
      def ssl?
        @env['rack.url_scheme'] == 'https' ||        #from of the rack docs
        @env['HTTP_X_FORWARDED_PROTO'] == 'https' || #set by the proxy
        @env['HTTPS'] == 'on'                        #from the Rails source for ss?
      end
      
      def ssl_authorized?
        !options['rack-bug.require_ssl'] || ssl?
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
  end
end