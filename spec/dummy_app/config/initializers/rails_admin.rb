require 'dragonfly/rails/images'

RailsAdmin.config do |c|
  c.actions do
    dashboard
    index
    show
    history_show
    history_index
    new
    edit
    export
    delete
    bulk_delete
  end
  
  c.audit_with :history, User
  c.excluded_models << RelTest

  c.model Team do
    include_all_fields
    field :color, :color
  end
end
