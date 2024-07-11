

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::StringLike do
  describe '#treat_empty_as_nil?', active_record: true do
    context 'with a nullable field' do
      subject do
        RailsAdmin.config('Team').fields.detect do |f|
          f.name == :name
        end.with(object: Team.new)
      end

      it 'is true' do
        expect(subject.treat_empty_as_nil?).to be true
      end
    end

    context 'with a non-nullable field' do
      subject do
        RailsAdmin.config('Team').fields.detect do |f|
          f.name == :manager
        end.with(object: Team.new)
      end

      it 'is false' do
        expect(subject.treat_empty_as_nil?).to be false
      end
    end
  end

  describe '#parse_input' do
    subject do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == :string_field
      end.with(object: FieldTest.new)
    end

    context 'with treat_empty_as_nil being true' do
      before do
        RailsAdmin.config FieldTest do
          field :string_field do
            treat_empty_as_nil true
          end
        end
      end

      context 'when value is empty' do
        let(:params) { {string_field: ''} }

        it 'makes the value nil' do
          subject.parse_input(params)
          expect(params.key?(:string_field)).to be true
          expect(params[:string_field]).to be nil
        end
      end

      context 'when value does not exist in params' do
        let(:params) { {} }

        it 'does not touch params' do
          subject.parse_input(params)
          expect(params.key?(:string_field)).to be false
        end
      end
    end

    context 'with treat_empty_as_nil being false' do
      before do
        RailsAdmin.config FieldTest do
          field :string_field do
            treat_empty_as_nil false
          end
        end
      end
      let(:params) { {string_field: ''} }

      it 'keeps the value untouched' do
        subject.parse_input(params)
        expect(params.key?(:string_field)).to be true
        expect(params[:string_field]).to eq ''
      end
    end
  end
end
