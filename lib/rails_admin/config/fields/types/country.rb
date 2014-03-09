require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Country < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :partial do
            :form_country
          end

          register_instance_option :locale do
            I18n.locale
          end

          register_instance_option :priority_countries do
            false
          end

          register_instance_option :only do
            false
          end

          register_instance_option :pretty_value do
            if value
              if (country = ISO3166::Country.new(value)) && country
                country.translations[locale.to_s]
              else
                value
              end
            else
              ' - '
            end
          end

          register_instance_option :export_value do
            value
          end

          # Return array for form builder
          def countries
            all_countries = country_options
            if priority_countries
              (all_countries & priority_countries) | all_countries
            else
              all_countries
            end
          end

          # Reader for validation errors of the bound object
          def errors
            bindings[:object].errors[name]
          end

          private

          # Return all requested country codes
          def all_country_codes
            codes = ISO3166::Country.all.map(&:last)
            if only.present?
              codes & only
            else
              codes
            end
          end

          # Prepare country codes
          def country_options_for(country_codes)
            I18n.with_locale(locale) do
              country_codes.map do |code|
                code = code.to_s.upcase
                country = ISO3166::Country.new(code)

                default_name = country.name
                localized_name = country.translations[I18n.locale.to_s]

                name = localized_name || default_name

                [name,code]
              end.sort
            end
          end

          # Return country options for all countries
          def country_options
            country_options_for(all_country_codes)
          end

        end
      end
    end
  end
end
