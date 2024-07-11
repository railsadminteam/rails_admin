

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Password do
  it_behaves_like 'a generic field type', :string_field, :password

  describe '#parse_input' do
    let(:field) do
      RailsAdmin.config(User).fields.detect do |f|
        f.name == :password
      end
    end

    context 'if password is not present' do
      let(:nil_params) { {password: nil} }
      let(:blank_params) { {password: ''} }

      it 'cleans nil' do
        field.parse_input(nil_params)
        expect(nil_params).to eq({})
        field.parse_input(blank_params)
        expect(blank_params).to eq({})
      end
    end

    context 'if password is present' do
      let(:params) { {password: 'aaa'} }

      it 'keeps the value' do
        field.parse_input(params)
        expect(params).to eq(password: 'aaa')
      end
    end
  end
end
