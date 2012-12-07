require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel
      def initialize(entity)
        @entity = entity
        @blocks = []
      end

      def method_missing(method, *args, &block)
        wake_up if asleep?

        @model.send(method, *args, &block)
      end

      def run(block)
        asleep? ? @blocks << block : @model.instance_eval(&block)
      end

      private

      def asleep?
        !awake?
      end

      def awake?
        @model
      end

      def wake_up
        @model = RailsAdmin::Config::Model.new(@entity)

        run_blocks
      end

      def run_blocks
        @blocks.each do |block|
          @model.instance_eval(&block)
        end
      end
    end
  end
end