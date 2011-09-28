#gem 'less-rails' # FIX ME. Remove from here and fix less-rails-bootstrap engine initializer
#gem 'less-rails-bootstrap'

RailsAdmin.config do |c|
  c.excluded_models << RelTest
end
