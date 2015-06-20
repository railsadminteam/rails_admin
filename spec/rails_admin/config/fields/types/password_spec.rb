require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Password do
  it_behaves_like 'a generic field type', :string_field, :password
end
