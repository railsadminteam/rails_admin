if defined?(::Devise)
  module Devise
    class FailureApp
      def scope
        @scope ||= warden_options[:scope] || Devise.default_scope
        @scope
      end
    end
  end
end
