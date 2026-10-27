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
      expect { visit new_path(model_name: 'field_test') }.not_to raise_error
      is_expected.to have_selector('trix-toolbar')
      next unless page.driver.respond_to?(:console)

      expect(page.driver.console.map(&:text)).to include(/ActionText assets should be loaded statically/)
      page.driver.console.clear
    end
  end
end
