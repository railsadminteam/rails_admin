module RailsAdmin
  module Config
    module Actions
      class Index < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :collection do
          true
        end
        
        register_instance_option :http_methods do
          [:get, :post]
        end
        
        register_instance_option :route_fragment do
          ''
        end
        
        register_instance_option :breadcrumb_parent do
          :dashboard
        end
        
        register_instance_option :controller do
          Proc.new do
            @objects ||= list_entries

            respond_to do |format|
              
              format.html do  
                render @action.template_name, :layout => !request.xhr?, :status => (flash[:error].present? ? :not_found : 200)
              end
              
              format.json do
                output = if params[:compact]
                  @objects.map{ |o| { :id => o.id, :label => o.send(@model_config.object_label_method) } }
                else
                  @objects.to_json(@schema)
                end
                if params[:send_data]
                  send_data output, :filename => "#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.json"
                else
                  render :json => output
                end
              end
              
              format.xml do
                output = @objects.to_xml(@schema)
                if params[:send_data]
                  send_data output, :filename => "#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.xml"
                else
                  render :xml => output
                end
              end
              
              format.csv do
                header, encoding, output = CSVConverter.new(@objects, @schema).to_csv(params[:csv_options])
                if params[:send_data]
                  send_data output,
                    :type => "text/csv; charset=#{encoding}; #{"header=present" if header}",
                    :disposition => "attachment; filename=#{params[:model_name]}_#{DateTime.now.strftime("%Y-%m-%d_%Hh%Mm%S")}.csv"
                else
                  render :text => output
                end
              end
              
            end
            
          end
        end
      end
    end
  end
end
