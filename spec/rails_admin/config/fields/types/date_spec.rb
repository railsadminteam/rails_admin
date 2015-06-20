require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Date do
  it_behaves_like 'a generic field type', :date_field, :date
end
