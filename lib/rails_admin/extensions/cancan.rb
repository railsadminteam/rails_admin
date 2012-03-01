require 'rails_admin/extensions/cancan/authorization_adapter'

RailsAdmin.add_extension(:cancan, RailsAdmin::Extensions::CanCan, {
  :authorization => true
})
