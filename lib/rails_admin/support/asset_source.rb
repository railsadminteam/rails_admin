# frozen_string_literal: true

module RailsAdmin
  module Support
    # Resolves the value of RailsAdmin.config.asset_source: passes through the
    # supported values, auto-detects when unset, maps deprecated values and
    # rejects the removed ones.
    module AssetSource
      class << self
        def resolve(value)
          case value
          when :propshaft, :sprockets, :external, Proc
            value
          when nil
            detect
          when :webpack
            warn '[RailsAdmin] config.asset_source = :webpack is deprecated, use :external instead.'
            :external
          when :importmap
            warn '[RailsAdmin] config.asset_source = :importmap is deprecated; RailsAdmin ships a prebuilt bundle now. ' \
                 'Use :propshaft / :sprockets or remove the setting.'
            detect
          when :webpacker, :vite
            raise "config.asset_source = :#{value} is no longer supported. Serve the bundled assets with " \
                  ':propshaft / :sprockets, build them yourself with :external, or pass a callable.'
          else
            raise "Unknown config.asset_source: #{value.inspect}"
          end
        end

        def detect
          return :propshaft if defined?(Propshaft)
          return :sprockets if defined?(Sprockets)

          :propshaft
        end
      end
    end
  end
end
