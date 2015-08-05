require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::FileUpload do
  it_behaves_like 'a generic field type', :string_field, :file_upload
end
