# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Wysihtml5 do
  before { allow(RailsAdmin.deprecator).to receive(:warn) }

  it_behaves_like 'a generic field type', :text_field, :wysihtml5

  it_behaves_like 'a string-like field type', :text_field, :wysihtml5

  it 'warns that the field type is deprecated' do
    RailsAdmin.config FieldTest do
      edit do
        field :text_field, :wysihtml5
      end
    end
    RailsAdmin.config('FieldTest').edit.fields
    expect(RailsAdmin.deprecator).to have_received(:warn).with(/wysihtml5 field type is deprecated/)
  end

  describe 'asset locations' do
    before do
      RailsAdmin.config FieldTest do
        edit do
          field :text_field, :wysihtml5
        end
      end
    end

    let(:field) { RailsAdmin.config('FieldTest').edit.fields.detect { |f| f.name == :text_field } }

    it 'serves the last bootstrap3-wysihtml5 release there is' do
      expect(field.js_location).to eq 'https://unpkg.com/bootstrap3-wysihtml5-bower@0.3.3/dist/bootstrap3-wysihtml5.all.min.js'
      expect(field.css_location).to eq 'https://unpkg.com/bootstrap3-wysihtml5-bower@0.3.3/dist/bootstrap3-wysihtml5.min.css'
    end
  end
end
