

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Citext do
  it_behaves_like 'a generic field type', :string_field

  it_behaves_like 'a string-like field type', :string_field
end
