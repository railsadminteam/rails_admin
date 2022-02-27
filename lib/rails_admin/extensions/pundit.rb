# frozen_string_literal: true

require 'rails_admin/extensions/pundit/authorization_adapter'

RailsAdmin.add_extension(:pundit, RailsAdmin::Extensions::Pundit, authorization: true)
