require 'rails_admin/extensions/cancancan/authorization_adapter'

RailsAdmin.add_extension(:cancan, RailsAdmin::Extensions::CanCanCan,
                         authorization: true
)
