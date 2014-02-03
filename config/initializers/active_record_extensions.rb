if defined?(::ActiveRecord)
  class ActiveRecord::Base
    def self.rails_admin(&block)
      RailsAdmin.config(self, &block)
    end

    def rails_admin_default_object_label_method
      self.new_record? ? "new #{self.class.to_s}" : "#{self.class.to_s} ##{id}"
    end

    def safe_send(value)
      if self.has_attribute?(value)
        read_attribute(value)
      else
        send(value)
      end
    end
  end
end
