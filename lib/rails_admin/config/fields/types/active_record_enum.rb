require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveRecordEnum < Enum
          RailsAdmin::Config::Fields::Types.register(self)

          def type
            :enum
          end

          register_instance_option :enum do
            Hash[defined_enums.map{|k, v| [i18n_method(k), v]}]
          end

          register_instance_option :pretty_value do
            i18n_name || bindings[:object].send(name).presence || ' - '
          end

          register_instance_option :multiple? do
            false
          end

          register_instance_option :queryable do
            false
          end

          def parse_value(value)
            value.present? ? defined_enums.invert[value.to_i] : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name]
          end

          def defined_enums
            abstract_model.model.defined_enums[name.to_s]
          end

          def i18n_method(method)
            _path = "enums.#{abstract_model.model.model_name.i18n_key.to_s}.#{name}.#{method}"
            I18n.exists?(_path) ? I18n.t(_path) : method
          end

          def i18n_name
            _path = "enums.#{abstract_model.model.model_name.i18n_key.to_s}.#{name}.#{bindings[:object].send(name)}"
            I18n.exists?(_path) ? I18n.t(_path) : nil
          end
        end
      end
    end
  end
end
