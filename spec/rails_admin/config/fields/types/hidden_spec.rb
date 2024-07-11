

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Hidden do
  it_behaves_like 'a generic field type', :integer_field, :hidden

  it_behaves_like 'a string-like field type', :string_field, :hidden
end
