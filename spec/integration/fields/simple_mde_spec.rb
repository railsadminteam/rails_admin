# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'SimpleMDE field', type: :request do
  subject { page }

  it 'works without error', js: true do
    RailsAdmin.config Draft do
      edit do
        field :notes, :simple_mde
      end
    end
    expect { visit new_path(model_name: 'draft') }.not_to raise_error
    is_expected.to have_selector('a[title="Markdown Guide"]')
  end

  it 'renders its content once its nested-form tab is shown, even when that tab was not the initially active one', js: true, active_record: true do
    RailsAdmin.config FieldTest do
      edit do
        field :nested_field_tests
      end
    end
    RailsAdmin.config NestedFieldTest do
      nested do
        field :title, :simple_mde
      end
    end

    field_test = FactoryBot.create(:field_test)
    field_test.nested_field_tests.create!(title: 'First page')
    field_test.nested_field_tests.create!(title: 'Second page')

    visit edit_path(model_name: 'field_test', id: field_test.id)
    container = find('#field_test_nested_field_tests_attributes_field')
    container.find('.toggler').click
    container.all('.nav-tabs .nav-link')[1].click

    second_pane = container.all('.tab-pane', visible: :all)[1]
    expect(second_pane).to have_css('.CodeMirror-line', text: 'Second page')
  end
end
