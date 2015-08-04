require 'spec_helper'

describe RailsAdmin::MainHelper, type: :helper do
  describe '#rails_admin_form_for' do
    let(:html_form) do
      helper.rails_admin_form_for(FieldTest.new, url: new_path(model_name: 'field_test')) {}
    end

    context 'with html5 browser_validations enabled' do
      before do
        RailsAdmin.config.browser_validations = true
        RailsAdmin.config FieldTest do
          field :address, :string do
            required true
          end
        end
      end

      it 'should not add novalidate attribute to the html form tag' do
        expect(html_form).to_not include 'novalidate'
      end
    end

    context 'with html5 browser_validations disabled' do
      before do
        RailsAdmin.config.browser_validations = false
        RailsAdmin.config FieldTest do
          field :address, :string do
            required true
          end
        end
      end

      it 'should add novalidate attribute to the html form tag' do
        expect(html_form).to include "novalidate=\"novalidate\""
      end
    end
  end
end
