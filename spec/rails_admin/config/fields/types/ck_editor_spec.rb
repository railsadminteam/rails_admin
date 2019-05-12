require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::CKEditor do
  it_behaves_like 'a generic field type', :text_field, :ck_editor
end
