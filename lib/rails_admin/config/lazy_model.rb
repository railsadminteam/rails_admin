require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel
      def initialize(entity, &block)
        @entity = entity
        @deferred_block = block
      end

      def method_missing(method, *args, &block)
        if !@model
          @model = RailsAdmin::Config::Model.new(@entity)
          @model.instance_eval(&@deferred_block) if @deferred_block
        end

        @model.send(method, *args, &block)
      end
    end
  end
end
