require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::BelongsToAssociation do
  it_behaves_like 'a generic field type', :integer_field, :belongs_to_association
end
