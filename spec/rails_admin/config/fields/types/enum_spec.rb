require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Enum do
  it_behaves_like 'a generic field type', :string_field, :enum
end
