require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Froala do
  it_behaves_like 'a generic field type', :text_field, :froala
end
