

RailsAdmin.config do |c|
  c.asset_source = CI_ASSET
  c.model Team do
    include_all_fields
    field :color, :hidden
  end

  if Rails.env.production?
    # Live demo configuration
    c.main_app_name = ['RailsAdmin', 'Live Demo']
    c.included_models = %w[Comment Division Draft Fan FieldTest League NestedFieldTest Player Team User]
    c.model 'FieldTest' do
      configure :paperclip_asset do
        visible false
      end
    end
  end
end
