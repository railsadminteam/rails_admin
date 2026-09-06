# frozen_string_literal: true

module RuboCop
  module Cop
    module RailsAdmin
      # Asks the abstract model for what it already answers, rather than going
      # around it to the model class.
      #
      #   # bad
      #   abstract_model.model.new
      #   abstract_model.model.name
      #
      #   # good
      #   abstract_model.dummy_record
      #   abstract_model.model_name
      #
      # Reaching the model class is not wrong in itself -- calling a method the
      # application defined, or using it as a Ruby class, has to go through it.
      # What this catches is the narrower mistake of spelling out the store's
      # own API where the facade has already been taught the question.
      class RawModelAccess < Base
        MSG = 'Ask the abstract model for `%{replacement}` rather than reaching its model class.'

        # Only methods AbstractModel answers itself. Anything else on a model
        # class -- .superclass, .respond_to?, a scope the application defined --
        # is left alone.
        REPLACEMENTS = {
          new: 'dummy_record',
          name: 'model_name',
          all: 'scoped',
          first: 'first',
          last: 'first(sort: primary_key)',
          where: 'where',
          count: 'count',
          columns: 'properties',
          human_attribute_name: 'human_attribute_name',
          primary_key: 'primary_key',
          table_name: 'table_name',
        }.freeze

        # @!method model_call(node)
        def_node_matcher :model_call, <<~PATTERN
          (send (send _ :model) $_ ...)
        PATTERN

        def on_send(node)
          return unless abstract_model_receiver?(node.receiver)

          model_call(node) do |method_name|
            replacement = REPLACEMENTS[method_name]
            next unless replacement

            add_offense(node, message: format(MSG, replacement: replacement))
          end
        end

      private

        def abstract_model_receiver?(node)
          return false unless node.respond_to?(:method_name) && node.method_name == :model

          receiver = node.receiver
          return false unless receiver

          name = receiver.respond_to?(:method_name) ? receiver.method_name.to_s : receiver.source
          name.end_with?('abstract_model')
        end
      end
    end
  end
end
