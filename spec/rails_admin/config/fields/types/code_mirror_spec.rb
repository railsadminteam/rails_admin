# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::CodeMirror do
  before { allow(RailsAdmin.deprecator).to receive(:warn) }

  it_behaves_like 'a generic field type', :text_field, :code_mirror

  it_behaves_like 'a string-like field type', :text_field, :code_mirror

  it 'warns that the field type is deprecated' do
    RailsAdmin.config FieldTest do
      edit do
        field :text_field, :code_mirror
      end
    end
    RailsAdmin.config('FieldTest').edit.fields
    expect(RailsAdmin.deprecator).to have_received(:warn).with(/code_mirror field type is deprecated/)
  end

  describe 'asset locations' do
    before do
      RailsAdmin.config FieldTest do
        edit do
          field :text_field, :code_mirror
        end
      end
    end

    let(:field) { RailsAdmin.config('FieldTest').edit.fields.detect { |f| f.name == :text_field } }
    let(:version) { RailsAdmin::Version.npm_dependency('codemirror') }

    it 'serves the pinned CodeMirror' do
      expect(field.js_location).to eq "https://unpkg.com/codemirror@#{version}/lib/codemirror.js"
      expect(field.css_location).to eq "https://unpkg.com/codemirror@#{version}/lib/codemirror.css"
    end

    it 'serves the mode and theme out of the same version' do
      expect(field.assets).to eq(
        mode: "https://unpkg.com/codemirror@#{version}/mode/css/css.js",
        theme: "https://unpkg.com/codemirror@#{version}/theme/night.css",
      )
    end
  end
end
