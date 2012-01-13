require 'dragonfly/rails/images'

RailsAdmin.config do |c|
  c.audit_with :history, User
  c.excluded_models << RelTest

  c.model Team do
    include_all_fields
    field :color, :color
  end
end
