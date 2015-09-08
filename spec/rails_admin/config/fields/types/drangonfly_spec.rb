require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Dragonfly do
  it_behaves_like 'a generic field type', :string_field, :dragonfly
end
