if defined?(::ActiveRecord)
  class ActiveRecord::Base
    def self.rails_admin(&block)
      ActiveSupport::Deprecation.warn("'#{self.name}.rails_admin { }' is deprecated, content is not evaluated anymore, use initializer instead", caller)
    end

    def rails_admin_default_object_label_method
      "#{self.class.to_s} ##{self.try :id}"
    end

    def safe_send(value)
      if self.attributes.find{ |k,v| k.to_s == value.to_s }
        self.read_attribute(value)
      else
        self.send(value)
      end
    end
  end
end
