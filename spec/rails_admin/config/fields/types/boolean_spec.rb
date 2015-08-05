require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Boolean do
  it_behaves_like 'a generic field type', :boolean_field, :boolean
end
