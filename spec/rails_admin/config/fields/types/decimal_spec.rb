require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Decimal do
  it_behaves_like 'a generic field type', :decimal_field, :decimal
end
