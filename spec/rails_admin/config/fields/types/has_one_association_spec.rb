

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::HasOneAssociation do
  it_behaves_like 'a generic field type', :integer_field, :has_one_association
end
