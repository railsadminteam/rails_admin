require 'dragonfly/rails/images'

RailsAdmin.config do |c|
  c.model Team do
    include_all_fields
    field :color, :color
  end

  c.model User do
    field :email do
      pretty_value do
        bindings[:view].tag(:a, { href: "#" }) << value
      end
    end
  end
end
