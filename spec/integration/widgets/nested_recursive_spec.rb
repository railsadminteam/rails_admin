# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Nested form for an association that can reach itself', type: :request do
  subject { page }

  # The cap keys off the generated object name, so it is the same code on either
  # adapter; only the way the models spell a recursive association differs.
  shared_examples 'a bounded recursive nested form' do |model_name, association|
    it 'renders, and stops nesting where the association has repeated enough' do
      visit new_path(model_name: model_name)

      expect(page.body.scan(%(data-nested-template="#{association}")).size).
        to eq RailsAdmin::FormBuilder::MAX_NESTED_FORM_RECURSION
    end

    it 'offers no add button where it renders no template' do
      visit new_path(model_name: model_name)

      expect(page.body.scan(%(data-nested-add="#{association}")).size).
        to eq RailsAdmin::FormBuilder::MAX_NESTED_FORM_RECURSION
    end
  end

  context 'on Mongoid, through recursively_embeds_many', mongoid: true do
    it_behaves_like 'a bounded recursive nested form', 'recursive_field_test', 'child_recursive_field_tests'

    it 'saves a child added through the form', js: true do
      visit new_path(model_name: 'recursive_field_test')

      fill_in 'recursive_field_test_title', with: 'root'
      find('#recursive_field_test_child_recursive_field_tests_attributes_field > .controls .add_nested_fields').click
      find('#recursive_field_test_child_recursive_field_tests_attributes_field > .tab-content' \
           ' > .fields.tab-pane.active > fieldset > .title_field input').set 'child'

      # trigger click via JS, workaround for instability in CI
      execute_script %(document.querySelector('button[name="_save"]').click())
      is_expected.to have_content('Recursive field test successfully created')

      expect(RecursiveFieldTest.find_by(title: 'root').child_recursive_field_tests.map(&:title)).to eq ['child']
    end
  end

  context 'on ActiveRecord, through a self-referential has_many', active_record: true do
    it_behaves_like 'a bounded recursive nested form', 'category', 'child_categories'
  end
end
