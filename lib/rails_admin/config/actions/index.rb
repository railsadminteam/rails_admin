# frozen_string_literal: true

require 'activemodel-serializers-xml'

module RailsAdmin
  module Config
    module Actions
      class Index < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :route_fragment do
          ''
        end

        register_instance_option :breadcrumb_parent do
          parent_model = bindings[:abstract_model].try(:config).try(:parent)
          am = parent_model && RailsAdmin.config(parent_model).try(:abstract_model)
          if am
            [:index, am]
          else
            [:dashboard]
          end
        end

        register_instance_option :controller do
          proc do
            association_scope = get_association_scope_from_params
            @objects ||= @association ? association_entries(@model_config, association_scope) : list_entries

            respond_to do |format|
              format.html do
                render @action.template_name, status: @status_code || :ok
              end

              format.json do
                output =
                  if params[:compact]
                    if @association
                      @association.collection(@objects).collect { |(label, id)| {id: id, label: label} }
                    else
                      @objects.collect { |object| {id: object.id.to_s, label: @model_config.object_label(object).to_s} }
                    end
                  else
                    @objects.to_json(@schema || serialization_schema.default)
                  end

                if params[:send_data]
                  send_data output, filename: "#{params[:model_name]}_#{DateTime.now.strftime('%Y-%m-%d_%Hh%Mm%S')}.json"
                else
                  render json: output, root: false
                end
              end

              format.xml do
                output = @objects.to_xml(@schema || serialization_schema.default)
                if params[:send_data]
                  send_data output, filename: "#{params[:model_name]}_#{DateTime.now.strftime('%Y-%m-%d_%Hh%Mm%S')}.xml"
                else
                  render xml: output
                end
              end

              format.csv do
                header, encoding, output = CSVConverter.new(@objects, @schema).to_csv(params[:csv_options].permit!.to_h)
                if params[:send_data]
                  send_data output,
                            type: "text/csv; charset=#{encoding}; #{'header=present' if header}",
                            disposition: "attachment; filename=#{params[:model_name]}_#{DateTime.now.strftime('%Y-%m-%d_%Hh%Mm%S')}.csv"
                else
                  render plain: output
                end
              end
            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-th-list'
        end
      end
    end
  end
end
