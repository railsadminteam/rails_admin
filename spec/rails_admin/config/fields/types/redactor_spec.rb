require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Redactor do
  it_behaves_like 'a generic field type', :text_field, :redactor
end