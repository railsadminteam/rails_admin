

require 'spec_helper'

RSpec.describe 'Nested many widget', type: :request, js: true do
  subject { page }

  let(:field_test) { FactoryBot.create :field_test }
  let(:nested_field_tests) { %w[1 2].map { |i| NestedFieldTest.create! title: "title #{i}", field_test: field_test } }
  before do
    RailsAdmin.config(FieldTest) do
      field :nested_field_tests
    end
  end

  it 'adds a new nested item' do
    visit edit_path(model_name: 'field_test', id: field_test.id)

    find('#field_test_nested_field_tests_attributes_field .add_nested_fields').click
    expect(page).to have_selector('.fields.tab-pane.active', visible: true)

    # trigger click via JS, workaround for instability in CI
    execute_script %(document.querySelector('button[name="_save"]').click())
    is_expected.to have_content('Field test successfully updated')

    expect(field_test.nested_field_tests.length).to eq(1)
  end

  it 'edits a nested item' do
    nested_field_tests
    visit edit_path(model_name: 'field_test', id: field_test.id)

    fill_in 'field_test_nested_field_tests_attributes_0_title', with: 'nested field test title 1 edited', visible: false
    edited_id = find('#field_test_nested_field_tests_attributes_0_id', visible: false).value

    # trigger click via JS, workaround for instability in CI
    execute_script %(document.querySelector('button[name="_save"]').click())
    is_expected.to have_content('Field test successfully updated')

    expect(field_test.nested_field_tests.find(edited_id).title).to eq('nested field test title 1 edited')
  end

  it 'deletes a nested item' do
    nested_field_tests
    visit edit_path(model_name: 'field_test', id: field_test.id)

    find('#field_test_nested_field_tests_attributes_0__destroy', visible: false).set('true')

    # trigger click via JS, workaround for instability in CI
    execute_script %(document.querySelector('button[name="_save"]').click())
    is_expected.to have_content('Field test successfully updated')

    expect(field_test.reload.nested_field_tests.map(&:id)).to eq [nested_field_tests[1].id]
  end

  it 'sets bindings[:object] to nested object', js: false do
    RailsAdmin.config(NestedFieldTest) do
      nested do
        field :title do
          label do
            bindings[:object].class.name
          end
        end
      end
    end
    nested_field_tests
    visit edit_path(model_name: 'field_test', id: field_test.id)
    expect(find('#field_test_nested_field_tests_attributes_0_title_field')).to have_content('NestedFieldTest')
  end

  it 'is deactivatable' do
    visit new_path(model_name: 'field_test')
    is_expected.to have_selector('#field_test_nested_field_tests_attributes_field .add_nested_fields')
    RailsAdmin.config(FieldTest) do
      configure :nested_field_tests do
        nested_form false
      end
    end
    visit new_path(model_name: 'field_test')
    is_expected.to have_no_selector('#field_test_nested_field_tests_attributes_field .add_nested_fields')
  end

  it 'is closable after adding a new item' do
    visit new_path(model_name: 'field_test')
    within('#field_test_nested_field_tests_attributes_field') do
      find('.add_nested_fields').click
      expect(page).to have_selector('.tab-content.collapse.show')
      expect(page).to have_selector('.nav .nav-link.active', visible: true)
      expect(page).to have_selector('.fields.tab-pane.active', visible: true)
      find(':scope > .controls .toggler').click
      expect(page).not_to have_selector('.tab-content.collapse.show')
      expect(page).not_to have_selector('.nav .nav-link.active', visible: true)
      expect(page).not_to have_selector('.fields.tab-pane.active', visible: true)
    end
  end

  it 'closes after removing all items' do
    visit new_path(model_name: 'field_test')
    within('#field_test_nested_field_tests_attributes_field') do
      find('.add_nested_fields').click
      expect(page).to have_selector('.tab-content.collapse.show')
      find(':scope > .tab-content > .fields > .remove_nested_fields', visible: false).click
      expect(page).not_to have_selector('.nav .nav-link.active', visible: true)
      expect(page).not_to have_selector('.fields.tab-pane.active', visible: true)
    end
  end

  context 'with nested_attributes_options given' do
    before do
      allow(FieldTest.nested_attributes_options).to receive(:[]).with(any_args).
        and_return(allow_destroy: true)
    end

    it 'does not show destroy button except for newly created when :allow_destroy is false', js: false do
      nested_field_tests
      allow(FieldTest.nested_attributes_options).to receive(:[]).with(:nested_field_tests).
        and_return(allow_destroy: false)
      visit edit_path(model_name: 'field_test', id: field_test.id)
      expect(find('#field_test_nested_field_tests_attributes_0_title').value).to eq('title 1')
      is_expected.not_to have_selector('form .remove_nested_fields')
      expect(find('div#nested_field_tests_fields_blueprint', visible: false)[:'data-blueprint']).to match(
        /<a[^>]* class="remove_nested_fields"[^>]*>/,
      )
    end
  end

  context "when a field which have the same name of nested_in field's" do
    it "does not hide fields which are not associated with nesting parent field's model" do
      visit new_path(model_name: 'field_test')
      is_expected.not_to have_selector('select#field_test_nested_field_tests_attributes_new_nested_field_tests_field_test_id')
      expect(find('div#nested_field_tests_fields_blueprint', visible: false)[:'data-blueprint']).to match(
        /<select[^>]* id="field_test_nested_field_tests_attributes_new_nested_field_tests_another_field_test_id"[^>]*>/,
      )
    end

    it 'hides fields that are deeply nested with inverse_of' do
      visit new_path(model_name: 'field_test')
      expect(page.body).to_not include('field_test_nested_field_tests_attributes_new_nested_field_tests_deeply_nested_field_tests_attributes_new_deeply_nested_field_tests_nested_field_test_id_field')
      expect(page.body).to include('field_test_nested_field_tests_attributes_new_nested_field_tests_deeply_nested_field_tests_attributes_new_deeply_nested_field_tests_title')
    end
  end

  context 'when XSS attack is attempted' do
    it 'does not break on adding a new item' do
      allow(I18n).to receive(:t).and_call_original
      expect(I18n).to receive(:t).with('admin.form.new_model', name: 'Nested field test').and_return('<script>throw "XSS";</script>')
      visit edit_path(model_name: 'field_test', id: field_test.id)
      find('#field_test_nested_field_tests_attributes_field .add_nested_fields').click
    end

    it 'does not break on editing an existing item' do
      NestedFieldTest.create! title: '<script>throw "XSS";</script>', field_test: field_test
      visit edit_path(model_name: 'field_test', id: field_test.id)
    end
  end
end
