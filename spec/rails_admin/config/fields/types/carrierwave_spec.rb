require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Carrierwave do
  it_behaves_like 'a generic field type', :string_field, :carrierwave
end
