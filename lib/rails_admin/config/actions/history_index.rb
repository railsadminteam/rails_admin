module RailsAdmin
  module Config
    module Actions
      class HistoryIndex < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :authorization_key do
          :history
        end

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :put] # NEW / ROLLBACK
        end

        register_instance_option :route_fragment do
          'history'
        end

        register_instance_option :controller do
          proc do
            @general = true
            @history = @auditing_adapter && @auditing_adapter.listing_for_model(@abstract_model, params[:query], params[:sort], params[:sort_reverse], params[:all], params[:page]) || []
            @version = PaperTrail::Version.find(params[:version_id]) if params[:version_id] rescue false

            if request.get? # SHOW

              if @version
                render partial: 'version', layout: false
              else
                render @action.template_name
              end

            elsif request.put? # ROLLBACK
              begin
                if @version.event == "create"
                  @record = @version.item_type.constantize.find(@version.item_id)
                  @result = @record.destroy
                else
                  @record = @version.reify
                  @result = @record.save
                end

                if @result
                  if @version.event == "create"
                    flash[:success] = "Rolled back newly-created record by destroying it."
                  else
                    flash[:success] = "Rolled back changes to this record."
                  end
                else
                  flash[:error] = "Couldn't rollback. Sorry."
                end
              rescue ActiveRecord::RecordNotFound
                flash[:error] = "Version does not exist."
                redirect_to :action => :history_index
              end

              redirect_to :action => :history_index
            end
          end
        end

        register_instance_option :template_name do
          :history
        end

        register_instance_option :link_icon do
          'icon-book'
        end
      end
    end
  end
end
