require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::ActiveRecordEnum, active_record: true do
  it_behaves_like 'a generic field type', :string_enum_field
end
