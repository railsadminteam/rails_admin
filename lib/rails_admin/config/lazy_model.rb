require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel < BasicObject
      def initialize(entity, &block)
        @entity = entity
        @deferred_blocks = [*block]
        @existing_blocks = []
      end

      def add_deferred_block(&block)
        @deferred_blocks << block
      end

      def target
        @model ||= ::RailsAdmin::Config::Model.new(@entity)
        # When evaluating multiple configuration blocks, the order of
        # execution is important. As one would expect (in my opinion),
        # options defined within a resource should take precedence over
        # more general options defined in an initializer. This way,
        # general settings for a number of resources could be specified
        # in the initializer, while models could override these settings
        # later, if required.
        #
        # CAVEAT: It cannot be guaranteed that blocks defined in an initializer
        # will be loaded (and adde to @deferred_blocks) first. For instance, if
        # the initializer references a model class before defining
        # a RailsAdmin configuration block, the configuration from the
        # resource will get added to @deferred_blocks first:
        #
        #     # app/models/some_model.rb
        #     class SomeModel
        #       rails_admin do
        #         :
        #       end
        #     end
        #
        #     # config/initializers/rails_admin.rb
        #     model = 'SomeModel'.constantize # blocks from SomeModel get loaded
        #     model.config model do           # blocks from initializer gets loaded
        #       :
        #     end
        #
        # Thus, sort all blocks to excute for a resource by Proc.source_path,
        # to guarantee that blocks from 'config/initializers' evaluate before
        # blocks defined within a model class.
        unless @deferred_blocks.empty?
          @existing_blocks += @deferred_blocks
          @existing_blocks.
            partition { |block| block.source_location.first =~ %r{config\/initializers} }.
            flatten.
            each { |block| @model.instance_eval(&block) }
          @deferred_blocks = []
        end
        @model
      end

      def method_missing(method, *args, &block)
        target.send(method, *args, &block)
      end

      def respond_to?(method, include_private = false)
        super || target.respond_to?(method, include_private)
      end
    end
  end
end
