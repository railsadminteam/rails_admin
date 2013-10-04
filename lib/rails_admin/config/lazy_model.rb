require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel
      def initialize(entity, &block)
        @entity = entity
        @deferred_blocks = block ? [ block ] : []
      end
      def add_deferred_block(&block)
        @deferred_blocks << block
      end
      def method_missing(method, *args, &block)
        if !@model
          @model = RailsAdmin::Config::Model.new(@entity)
          # Configuration defined in the model class should take precedence
          # over configuration defined in initializers/rails_admin.rb.
          #
          # Due to the way the Rails initialization process works,
          # configuration blocks found in app/models/MODEL.rb are added to
          # @deferred_bocks before blocks defined in initializers/rails_admin.rb. 
          # Executing blocks in the order of addition would yield unexpected
          # behaviour, as blocks from the initializer would overwrite settings 
          # defined in model classes.
          #
          # In order to maintain the expected precedence (model configuration over
          # initializer configuration), all blocks are executed in reverse order.
          #
          # Given the following code containing initialization blocks:
          #
          #     # app/models/some_model.rb
          #     class SomeModel
          #       rails_admin do
          #         :
          #       end
          #     end
          #
          #     # config/initializers/rails_admin.rb
          #     config.model SomeModel do
          #       :
          #     end
          #
          # The block from app/models/some_model.rb will be added to
          # @deferred_blocks in front of the one from config/initializers/rails_admin.rb.
          # In order to give precedence to the block from SomeModel,
          # execute blocks in reverse order.
          #
          # CAVEAT: if, for some reason, a model would specify multiple configuration
          # blocks, later blocks would be executed before earlier blocks - which could
          # result in unexpected behaviour. However (and therefore), defining multiple
          # configuration blocks within a single model class are discouraged.
          @deferred_blocks.flatten.reverse.each do |block|
            @model.instance_eval(&block)
          end
        end
        @model.send(method, *args, &block)
      end
    end
  end
end
