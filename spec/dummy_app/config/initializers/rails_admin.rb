# frozen_string_literal: true

RailsAdmin.config do |c|
  c.model 'Team' do
    include_all_fields
    field :color, :color
  end
end
