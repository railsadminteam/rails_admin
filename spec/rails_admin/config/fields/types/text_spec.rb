require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Text do
  it_behaves_like 'a generic field type', :text_field, :text
end
