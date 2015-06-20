require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Time do
  it_behaves_like 'a generic field type', :time_field, :time
end
