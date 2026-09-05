# frozen_string_literal: true

ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    class Base
      def self.rails_admin(&block)
        RailsAdmin.config(self, &block)
      end

      def safe_send(value)
        RailsAdmin.deprecator.warn('#safe_send is deprecated, please use RailsAdmin::AbstractModel#read.')
        if has_attribute?(value)
          read_attribute(value)
        else
          send(value)
        end
      end
    end
  end
end
