# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::CKEditor do
  before { allow(RailsAdmin.deprecator).to receive(:warn) }

  it_behaves_like 'a generic field type', :text_field, :ck_editor

  it_behaves_like 'a string-like field type', :text_field, :ck_editor

  it 'warns that the field type is deprecated' do
    RailsAdmin.config FieldTest do
      edit do
        field :text_field, :ck_editor
      end
    end
    RailsAdmin.config('FieldTest').edit.fields
    expect(RailsAdmin.deprecator).to have_received(:warn).with(/ck_editor field type is deprecated/)
  end

  it 'names no editor to load until the application configures one' do
    RailsAdmin.config FieldTest do
      edit do
        field :text_field, :ck_editor
      end
    end
    field = RailsAdmin.config('FieldTest').edit.fields.detect { |f| f.name == :text_field }
    expect(field.base_location).to be_nil
  end
end
