

module RailsAdmin
  class MainController < RailsAdmin::ApplicationController
    include ActionView::Helpers::TextHelper
    include RailsAdmin::MainHelper
    include RailsAdmin::ApplicationHelper

    before_action :check_for_cancel

    def bulk_action
      get_model
      process(params[:bulk_action]) if params[:bulk_action].in?(RailsAdmin::Config::Actions.all(:bulkable, controller: self, abstract_model: @abstract_model).collect(&:route_fragment))
    end

    def list_entries(model_config = @model_config, auth_scope_key = :index, additional_scope = get_association_scope_from_params, pagination = !(params[:associated_collection] || params[:all] || params[:bulk_ids]))
      scope = model_config.scope
      auth_scope = @authorization_adapter&.query(auth_scope_key, model_config.abstract_model)
      scope = scope.merge(auth_scope) if auth_scope
      scope = scope.instance_eval(&additional_scope) if additional_scope
      get_collection(model_config, scope, pagination)
    end

  private

    def action_missing(name, *_args)
      action = RailsAdmin::Config::Actions.find(name.to_sym)
      raise AbstractController::ActionNotFound.new("The action '#{name}' could not be found for #{self.class.name}") unless action

      get_model unless action.root?
      get_object if action.member?
      @authorization_adapter.try(:authorize, action.authorization_key, @abstract_model, @object)
      @action = action.with({controller: self, abstract_model: @abstract_model, object: @object})
      raise(ActionNotAllowed) unless @action.enabled?

      @page_name = wording_for(:title)

      instance_eval(&@action.controller)
    end

    def method_missing(name, *args, &block)
      action = RailsAdmin::Config::Actions.find(name.to_sym)
      if action
        action_missing name, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(sym, include_private)
      if RailsAdmin::Config::Actions.find(sym)
        true
      else
        super
      end
    end

    def back_or_index
      allowed_return_to?(params[:return_to].to_s) ? params[:return_to] : index_path
    end

    def allowed_return_to?(url)
      url != request.fullpath && url.start_with?(request.base_url, '/') && !url.start_with?('//')
    end

    def get_sort_hash(model_config)
      field = model_config.list.fields.detect { |f| f.name.to_s == params[:sort] }
      # If no sort param, default to the `sort_by` specified in the list config
      field ||= model_config.list.possible_fields.detect { |f| f.name == model_config.list.sort_by.try(:to_sym) }

      column =
        if field.nil? || field.sortable == false # use default sort, asked field does not exist or is not sortable
          model_config.list.sort_by
        else
          field.sort_column
        end

      params[:sort_reverse] ||= 'false'
      {sort: column, sort_reverse: (params[:sort_reverse] == (field&.sort_reverse&.to_s || 'true'))}
    end

    def redirect_to_on_success
      notice = I18n.t('admin.flash.successful', name: @model_config.label, action: I18n.t("admin.actions.#{@action.key}.done"))
      if params[:_add_another]
        redirect_to new_path(return_to: params[:return_to]), flash: {success: notice}
      elsif params[:_add_edit]
        redirect_to edit_path(id: @object.id, return_to: params[:return_to]), flash: {success: notice}
      else
        redirect_to back_or_index, flash: {success: notice}
      end
    end

    def visible_fields(action, model_config = @model_config)
      model_config.send(action).with(controller: self, view: view_context, object: @object).visible_fields
    end

    def sanitize_params_for!(action, model_config = @model_config, target_params = params[@abstract_model.param_key])
      return unless target_params.present?

      fields = visible_fields(action, model_config)
      allowed_methods = fields.collect(&:allowed_methods).flatten.uniq.collect(&:to_s) << 'id' << '_destroy'
      fields.each { |field| field.parse_input(target_params) }
      target_params.slice!(*allowed_methods)
      target_params.permit! if target_params.respond_to?(:permit!)
      fields.select(&:nested_form).each do |association|
        children_params = association.multiple? ? target_params[association.method_name].try(:values) : [target_params[association.method_name]].compact
        (children_params || []).each do |children_param|
          sanitize_params_for!(:nested, association.associated_model_config, children_param)
        end
      end
    end

    def handle_save_error(whereto = :new)
      flash.now[:error] = I18n.t('admin.flash.error', name: @model_config.label, action: I18n.t("admin.actions.#{@action.key}.done").html_safe).html_safe
      flash.now[:error] += %(<br>- #{@object.errors.full_messages.join('<br>- ')}).html_safe

      respond_to do |format|
        format.html { render whereto, status: :not_acceptable }
        format.js   { render whereto, layout: 'rails_admin/modal', status: :not_acceptable, content_type: Mime[:html].to_s }
      end
    end

    def check_for_cancel
      return unless params[:_continue] || (params[:bulk_action] && !params[:bulk_ids])

      redirect_to(back_or_index, notice: I18n.t('admin.flash.noaction'))
    end

    def get_collection(model_config, scope, pagination)
      section = @action.key == :export ? model_config.export : model_config.list
      eager_loads = section.fields.flat_map(&:eager_load_values)
      options = {}
      options = options.merge(page: (params[Kaminari.config.param_name] || 1).to_i, per: (params[:per] || model_config.list.items_per_page)) if pagination
      options = options.merge(include: eager_loads) unless eager_loads.blank?
      options = options.merge(get_sort_hash(model_config))
      options = options.merge(query: params[:query]) if params[:query].present?
      options = options.merge(filters: params[:f]) if params[:f].present?
      options = options.merge(bulk_ids: params[:bulk_ids]) if params[:bulk_ids]
      model_config.abstract_model.all(options, scope)
    end

    def get_association_scope_from_params
      return nil unless params[:associated_collection].present?

      source_abstract_model = RailsAdmin::AbstractModel.new(to_model_name(params[:source_abstract_model]))
      source_model_config = source_abstract_model.config
      source_object = source_abstract_model.get(params[:source_object_id])
      action = params[:current_action].in?(%w[create update]) ? params[:current_action] : 'edit'
      @association = source_model_config.send(action).fields.detect { |f| f.name == params[:associated_collection].to_sym }.with(controller: self, object: source_object)
      @association.associated_collection_scope
    end
  end
end
