#gem 'less-rails' # FIX ME. Remove from here and fix less-rails-bootstrap engine initializer
#gem 'less-rails-bootstrap'

RailsAdmin.config do |c|
  c.excluded_models << RelTest
  
  c.model Team do
    include_all_fields
    field :color, :color
  end
end
