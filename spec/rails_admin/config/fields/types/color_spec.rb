require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Color do
  it_behaves_like 'a generic field type', :string_field, :color
end
