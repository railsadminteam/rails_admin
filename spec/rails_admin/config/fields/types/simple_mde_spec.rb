require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::SimpleMDE do
  it_behaves_like 'a generic field type', :text_field, :simple_mde
end
