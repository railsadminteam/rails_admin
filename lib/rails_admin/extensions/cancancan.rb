require 'rails_admin/extensions/cancancan/authorization_adapter'

RailsAdmin.add_extension(:cancancan, RailsAdmin::Extensions::CanCanCan, authorization: true)
