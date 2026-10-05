# frozen_string_literal: true

require 'rails_admin/support/hash_helper'

module RailsAdmin
  # The options passed to to_json/to_xml, limited to what a section exposes.
  # It mirrors what the export form offers, as the form is what builds them.
  class SerializationSchema
    def initialize(section, include_associations:)
      @section = section
      @include_associations = include_associations
    end

    def default
      sanitize(allowed)
    end

    # Anything not allowed is dropped, and `only` is always set, since leaving
    # it out makes to_json/to_xml serialize every attribute.
    def sanitize(requested)
      requested = HashHelper.symbolize(requested)
      schema = filter(requested, allowed)
      if @include_associations && requested[:include].is_a?(Hash)
        schema[:include] = requested[:include].each_with_object({}) do |(name, value), included|
          next unless value.is_a?(Hash) && allowed[:include].key?(name)

          included[name] = filter(value, allowed[:include][name])
        end
      end
      schema
    end

  private

    def allowed
      @allowed ||= begin
        fields = @section.visible_fields
        names = field_names(fields.select { |f| !f.association? || f.association.polymorphic? })
        if @include_associations
          names[:include] = fields.select { |f| f.association? && !f.association.polymorphic? }.to_h do |field|
            associated = field.associated_model_config.export.with(@section.bindings.merge(object: field.associated_model_config.abstract_model.dummy_record))
            [field.name, field_names(associated.visible_fields.reject(&:association?))]
          end
        else
          # The list shows these associations already, so their keys expose nothing more
          names[:only].concat(fields.select { |f| f.association? && f.association.type == :belongs_to && !f.association.polymorphic? }.
            flat_map { |f| Array(f.association.foreign_key) })
        end
        names
      end
    end

    def field_names(fields)
      fields.each_with_object({only: [], methods: []}) do |field, names|
        list = field.virtual? ? names[:methods] : names[:only]
        if field.association?
          list << field.method_name.to_sym << field.association.foreign_type.to_sym
        else
          list << field.name
        end
      end
    end

    def filter(requested, permitted)
      only = Array(requested[:only]) & permitted[:only]
      # Mongoid serializes every attribute for an empty `only`
      schema = {only: only.presence || [:__none__]}
      schema[:methods] = Array(requested[:methods]) & permitted[:methods] if requested.key?(:methods)
      schema
    end
  end
end
