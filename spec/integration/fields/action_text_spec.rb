

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

    if RailsAdmin.config.asset_source == :sprockets && Rails.gem_version < Gem::Version.new('7.0')
      it 'shows a warning if ActionText assets are loaded dynamically' do
        expect(ConsoleLogger).to receive(:warn).with(/ActionText assets should be loaded statically/)
        visit new_path(model_name: 'field_test')
        is_expected.to have_selector('trix-toolbar')
      end

      it 'allows suppressing the warning' do
        RailsAdmin.config FieldTest do
          edit do
            field :action_text_field do
              warn_dynamic_load false
            end
          end
        end
        expect(ConsoleLogger).not_to receive(:warn).with(/ActionText assets should be loaded statically/)
        visit new_path(model_name: 'field_test')
        is_expected.to have_selector('trix-toolbar')
      end
    end
  end
end
