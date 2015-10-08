require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::CodeMirror do
  it_behaves_like 'a generic field type', :text_field, :code_mirror
end
