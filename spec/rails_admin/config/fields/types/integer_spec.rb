

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Integer do
  it_behaves_like 'a generic field type', :integer_field, :integer
end
