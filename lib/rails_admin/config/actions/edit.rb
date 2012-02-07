module RailsAdmin
  module Config
    module Actions
      class Edit < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)        
        
        register_instance_option :member do
          true
        end
        
        register_instance_option :http_methods do
          [:get, :put]
        end
        
        register_instance_option :controller do
          Proc.new do
            
            if request.get? # EDIT

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
              end
            
            elsif request.put? # UPDATE
            
              @cached_assocations_hash = associations_hash
              @attributes = get_attributes
              @modified_assoc = []
      
              @old_object = @object.dup
              @model_config.update.fields.map { |f| f.parse_input(@attributes) if f.respond_to?(:parse_input) }
              @object.set_attributes(@attributes, _attr_accessible_role)

              if @object.save
                @auditing_adapter && @auditing_adapter.update_object(@abstract_model, @object, @cached_assocations_hash, associations_hash, @modified_assoc, @old_object, _current_user)
                respond_to do |format|
                  format.html { redirect_to_on_success }
                  format.js { render :json => { :id => @object.id, :label => @model_config.with(:object => @object).object_label } }
                end
              else
                handle_save_error :edit
              end
              
            end

          end
        end
      
        register_instance_option :link_icon do
          'icon-pencil'
        end        
      end
    end
  end
end
