require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel
      def initialize(entity)
        @entity = entity
      end

      def method_missing(method, *args, &block)
        if @block
          @model = RailsAdmin::Config::Model.new(@entity)
          @model.instance_eval(&@block)
          @block = nil
        else
          @model ||= RailsAdmin::Config::Model.new(@entity)
        end
        @model.send(method, *args, &block)
      end

      def store(block)
        if @block
          raise "Only one config block per model is allowed. Please check configurations blocks for #{@entity}. "
        end
        @block = block
      end
    end
  end
end