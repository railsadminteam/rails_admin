# frozen_string_literal: true

module RuboCop
  module Cop
    module RailsAdmin
      # Keeps the adapters out of sight of the layers above them.
      #
      #   # bad, in lib/rails_admin/config or a view
      #   RailsAdmin::Adapters::ActiveRecord::Property
      #
      # Config says what the admin should show, in its own vocabulary, and asks
      # the abstract model for the rest. Naming an adapter is how a branch on
      # "which ORM is this" gets started, which is what the two halves of an
      # adapter exist to make unnecessary.
      class AdapterReference < Base
        MSG = 'Do not name an adapter here; ask the abstract model instead.'

        def on_const(node)
          add_offense(node) if node.source.start_with?('RailsAdmin::Adapters::', 'Adapters::')
        end
      end
    end
  end
end
