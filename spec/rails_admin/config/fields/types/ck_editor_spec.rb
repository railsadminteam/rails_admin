require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::CKEditor do
  it_behaves_like 'a generic field type', :text_field, :ck_editor

  it_behaves_like 'a string-ish field type', :text_field, :ck_editor
end
