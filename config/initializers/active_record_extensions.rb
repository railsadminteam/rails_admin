

ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    class Base
      def self.rails_admin(&block)
        RailsAdmin.config(self, &block)
      end

      def rails_admin_default_object_label_method
        new_record? ? "new #{self.class}" : "#{self.class} ##{id}"
      end

      def safe_send(value)
        if has_attribute?(value)
          read_attribute(value)
        else
          send(value)
        end
      end
    end
  end

  if defined?(CompositePrimaryKeys)
    # Apply patch until the fix is released:
    #   https://github.com/composite-primary-keys/composite_primary_keys/pull/572
    CompositePrimaryKeys::CompositeKeys.class_eval do
      alias_method :to_param, :to_s
    end

    CompositePrimaryKeys::CollectionAssociation.prepend(Module.new do
      def ids_writer(ids)
        if reflection.association_primary_key.is_a? Array
          ids = CompositePrimaryKeys.normalize(Array(ids).reject(&:blank?), reflection.association_primary_key.size)
          reflection.association_primary_key.each_with_index do |primary_key, i|
            pk_type = klass.type_for_attribute(primary_key)
            ids.each do |id|
              id[i] = pk_type.cast(id[i]) if id.is_a? Array
            end
          end
        end
        super ids
      end
    end)
  end
end
