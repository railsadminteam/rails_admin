# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::EasyMDE do
  it_behaves_like 'a generic field type', :text_field, :easy_mde

  it_behaves_like 'a string-like field type', :text_field, :easy_mde

  it 'is also registered under the name it used to have' do
    expect(RailsAdmin::Config::Fields::Types.load(:simple_mde)).to eq described_class
  end

  describe 'asset locations' do
    before do
      RailsAdmin.config FieldTest do
        edit do
          field :text_field, :easy_mde
        end
      end
    end

    let(:field) { RailsAdmin.config('FieldTest').edit.fields.detect { |f| f.name == :text_field } }
    let(:version) { RailsAdmin::Version.npm_dependency('easymde') }

    it 'serves the pinned EasyMDE' do
      expect(field.js_location).to eq "https://unpkg.com/easymde@#{version}/dist/easymde.min.js"
      expect(field.css_location).to eq "https://unpkg.com/easymde@#{version}/dist/easymde.min.css"
    end
  end
end
