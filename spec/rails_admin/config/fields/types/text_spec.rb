

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Text do
  it_behaves_like 'a generic field type', :text_field

  it_behaves_like 'a string-like field type', :text_field
end
