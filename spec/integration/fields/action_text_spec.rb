# frozen_string_literal: true

require 'spec_helper'

if defined?(ActionText)
  RSpec.describe 'ActionText field', type: :request, js: true do
    subject { page }

    before do
      RailsAdmin.config FieldTest do
        edit do
          field :action_text_field
        end
      end
    end

    it 'works without error' do
      allow(ConsoleLogger).to receive(:warn).with(/ActionText assets should be loaded statically/)
      expect { visit new_path(model_name: 'field_test') }.not_to raise_error
      is_expected.to have_selector('trix-toolbar')
    end
  end
end
