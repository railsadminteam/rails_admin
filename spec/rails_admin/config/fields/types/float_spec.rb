require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Float do
  it_behaves_like 'a generic field type', :float_field, :float
end
