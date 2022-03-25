# frozen_string_literal: true

RailsAdmin.config do |c|
  c.asset_source = CI_ASSET
  c.model Team do
    include_all_fields
    field :color, :color
  end
end
