require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Refile do
  it_behaves_like 'a generic field type', :string_field, :refile
end
