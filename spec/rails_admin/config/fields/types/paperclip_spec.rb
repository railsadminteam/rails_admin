require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Paperclip do
  it_behaves_like 'a generic field type', :string_field, :paperclip
end
