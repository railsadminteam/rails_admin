require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Wysihtml5 do
  it_behaves_like 'a generic field type', :text_field, :wysihtml5
end
