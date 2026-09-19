# frozen_string_literal: true

module RuboCop
  module Cop
    module RailsAdmin
      # Hands records back the way the model made them.
      #
      #   # bad
      #   model.new(params).extend(ObjectExtension)
      #   object.singleton_class.after_create { ... }
      #
      # Anything added to a record individually makes it something other than
      # the model's own instance, and the ways that shows up are not obvious:
      # a proxy is not matched by `case record when Player` (#2847), and an
      # object carrying a singleton cannot be dumped, so Rails.cache.write of
      # it raises.
      #
      # When behaviour has to differ per record, bind a field to it --
      # `field.with(object: record)` -- or put it on the repository, which takes
      # the record as an argument.
      class RecordDecoration < Base
        MSG = 'Do not add anything to a record; it stops being the instance the model makes.'

        RESTRICT_ON_SEND = %i[extend singleton_class define_singleton_method].freeze

        def on_send(node)
          return unless node.receiver
          return if node.receiver.self_type?

          add_offense(node)
        end
      end
    end
  end
end
