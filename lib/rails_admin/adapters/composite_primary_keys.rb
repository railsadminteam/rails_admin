

require 'rails_admin/adapters/active_record'
require 'rails_admin/adapters/composite_primary_keys/association'

module RailsAdmin
  module Adapters
    module CompositePrimaryKeys
      include RailsAdmin::Adapters::ActiveRecord

      def get(id, scope = scoped)
        begin
          object = scope.find(id)
        rescue ::ActiveRecord::RecordNotFound
          return nil
        end

        object.extend(RailsAdmin::Adapters::ActiveRecord::ObjectExtension)
      end

      def associations
        model.reflect_on_all_associations.collect do |association|
          RailsAdmin::Adapters::CompositePrimaryKeys::Association.new(association, model)
        end
      end

    private

      def bulk_scope(scope, options)
        if primary_key.is_a? Array
          options[:bulk_ids].map do |id|
            scope.where(primary_key.zip(::CompositePrimaryKeys::CompositeKeys.parse(id)).to_h)
          end.reduce(&:or)
        else
          super
        end
      end
    end
  end
end
