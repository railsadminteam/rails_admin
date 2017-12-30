module RailsAdmin
  module Config
    module Actions
      class AssociationIndex < RailsAdmin::Config::Actions::Base
        def self.register_assoc(assoc_name)
          # Create association action constant
          action_class = ::RailsAdmin::Config::Actions.const_set(
            assoc_name.to_s.camelize,
            Class.new(self),
          )

          ::RailsAdmin::Config::Actions.register(assoc_name, action_class)
        end

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          %i(get)
        end

        register_instance_option :controller do
          proc do
            assoc_scope = @object.public_send(@action.assoc_name)
            assoc_model = assoc_scope.new.class

            @assoc_abstract_model = ::RailsAdmin::AbstractModel.new(assoc_model)
            @assoc_model_config = @assoc_abstract_model.config

            @objects = list_entries(@assoc_model_config).merge(assoc_scope)

            respond_to do |format|
              format.html do
                render @action.template_name, status: @status_code || :ok
              end
            end
          end
        end

        register_instance_option :link_icon do
          'icon-list'
        end

        register_instance_option :assoc_name do
          custom_key
        end

        register_instance_option :template_name do
          :association_index
        end
      end
    end
  end
end
