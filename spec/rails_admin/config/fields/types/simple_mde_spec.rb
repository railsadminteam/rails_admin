

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::SimpleMDE do
  it_behaves_like 'a generic field type', :text_field, :simple_mde

  it_behaves_like 'a string-like field type', :text_field, :simple_mde
end
