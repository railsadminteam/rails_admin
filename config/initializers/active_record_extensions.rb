if defined?(::ActiveRecord)
  class ActiveRecord::Base
    def rails_admin_default_object_label_method
      "#{self.class.to_s} ##{self.try :id}"
    end
  end
end