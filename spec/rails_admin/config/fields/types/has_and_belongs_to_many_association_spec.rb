

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::HasAndBelongsToManyAssociation do
  it_behaves_like 'a generic field type', :integer_field, :has_and_belongs_to_many_association
end
