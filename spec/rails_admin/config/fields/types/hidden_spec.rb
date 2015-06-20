require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Hidden do
  it_behaves_like 'a generic field type', :integer_field, :hidden
end
