

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::HasManyAssociation do
  it_behaves_like 'a generic field type', :integer_field, :has_many_association
end
