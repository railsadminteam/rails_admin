module RailsAdmin
  module Config
    module Actions
      class BulkDelete < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:post, :delete]
        end

        register_instance_option :controller do
          proc do
            if request.post? # BULK DELETE

              @objects = list_entries(@model_config, :destroy)

              render @action.template_name

            elsif request.delete? # BULK DESTROY

              @objects = list_entries(@model_config, :destroy)
              processed_objects = @abstract_model.destroy(@objects)

              destroyed = processed_objects.select(&:destroyed?)
              not_destroyed = processed_objects - destroyed

              destroyed.each do |object|
                @auditing_adapter && @auditing_adapter.delete_object(object, @abstract_model, _current_user)
              end

              flash[:success] = t('admin.flash.successful', name: pluralize(destroyed.count, @model_config.label), action: t('admin.actions.delete.done')) unless destroyed.empty?
              flash[:error] = t('admin.flash.error', name: pluralize(not_destroyed.count, @model_config.label), action: t('admin.actions.delete.done')) unless not_destroyed.empty?

              redirect_to back_or_index

            end
          end
        end

        register_instance_option :authorization_key do
          :destroy
        end

        register_instance_option :bulkable? do
          true
        end
      end
    end
  end
end
