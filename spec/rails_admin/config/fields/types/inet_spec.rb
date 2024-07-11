

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Inet do
  it_behaves_like 'a generic field type', :string_field, :inet
end
