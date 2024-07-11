

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Color do
  it_behaves_like 'a generic field type', :string_field, :color

  it_behaves_like 'a string-like field type', :string_field, :color
end
