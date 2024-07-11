

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Float do
  it_behaves_like 'a float-like field type', :float_field
end
