require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Array do
  it_behaves_like 'a generic field type', :text_field, :array
end
