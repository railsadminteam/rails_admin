

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::CodeMirror do
  it_behaves_like 'a generic field type', :text_field, :code_mirror

  it_behaves_like 'a string-like field type', :text_field, :code_mirror
end
