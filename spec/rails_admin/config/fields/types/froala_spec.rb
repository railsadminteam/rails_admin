require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Froala do
  it_behaves_like 'a generic field type', :text_field, :froala
end
