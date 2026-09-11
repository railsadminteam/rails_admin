# frozen_string_literal: true

require 'rails_admin/adapters/reflection'
require 'rails_admin/adapters/active_record/association'
require 'rails_admin/adapters/active_record/property'

module RailsAdmin
  module Adapters
    module ActiveRecord
      class Reflection < RailsAdmin::Adapters::Reflection
        def associations
          model.reflect_on_all_associations.collect do |association|
            Association.new(association, model)
          end
        end

        def properties
          columns = model.columns.reject do |c|
            c.type.blank? ||
              DISABLED_COLUMN_TYPES.include?(c.type.to_sym) ||
              c.try(:array)
          end
          columns.collect do |property|
            Property.new(property, model)
          end
        end

        def base_class
          model.base_class
        end

        delegate :primary_key, :table_name, to: :model, prefix: false

        def quoted_table_name
          model.quoted_table_name
        end

        def quote_column_name(name)
          model.connection.quote_column_name(name)
        end

        def encoding
          adapter =
            if ::ActiveRecord::Base.respond_to?(:connection_db_config)
              ::ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
            else
              ::ActiveRecord::Base.connection_config[:adapter]
            end
          case adapter
          when 'postgresql'
            ::ActiveRecord::Base.connection.select_one("SELECT ''::text AS str;").values.first.encoding
          when 'mysql2'
            if RUBY_ENGINE == 'jruby'
              ::ActiveRecord::Base.connection.select_one("SELECT '' AS str;").values.first.encoding
            else
              ::ActiveRecord::Base.connection.raw_connection.encoding
            end
          when 'oracle_enhanced'
            ::ActiveRecord::Base.connection.select_one('SELECT dummy FROM DUAL').values.first.encoding
          else
            ::ActiveRecord::Base.connection.select_one("SELECT '' AS str;").values.first.encoding
          end
        end

        def embedded?
          false
        end

        def cyclic?
          false
        end

        def adapter_supports_joins?
          true
        end

        def belongs_to_required_by_default
          model.belongs_to_required_by_default
        end

        def attribute_enum_values(name)
          model.defined_enums[name.to_s]
        end
      end
    end
  end
end
