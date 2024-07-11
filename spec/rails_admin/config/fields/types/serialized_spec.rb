

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Serialized do
  it_behaves_like 'a generic field type', :text_field, :serialized
end
