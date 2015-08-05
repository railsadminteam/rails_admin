require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::BsonObjectId do
  it_behaves_like 'a generic field type', :string_field, :bson_object_id
end
