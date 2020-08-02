require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::MultipleActiveStorage do
  it_behaves_like 'a generic field type', :string_field, :multiple_active_storage

  let(:record) { FactoryBot.create :field_test }
  let(:field) do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == :active_storage_assets
    end.with(
      object: record,
      view: ApplicationController.new.view_context,
    )
  end

  describe RailsAdmin::Config::Fields::Types::MultipleActiveStorage::ActiveStorageAttachment do
    describe '#pretty_value' do
      subject { field.pretty_value }

      context 'when attachment is not an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.txt", content_type: "text/plain"}] }

        it 'uses filename as link text' do
          expect(Nokogiri::HTML(subject).text).to eq 'test.txt'
        end
      end

      context 'when the field is an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.jpg", content_type: "image/jpeg"}] }

        it 'shows thumbnail image with a link' do
          expect(Nokogiri::HTML(subject).css('img').attribute('src').value).to match(%r{rails/active_storage/representations})
          expect(Nokogiri::HTML(subject).css('a').attribute('href').value).to match(%r{rails/active_storage/blobs})
        end
      end
    end

    describe '#image?' do
      context 'when attachment is an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.jpg", content_type: "image/jpeg"}] }

        it 'returns true' do
          expect(field.attachments[0].image?).to be_truthy
        end
      end

      context 'when attachment is not an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.txt", content_type: "text/plain"}] }

        it 'returns false' do
          expect(field.attachments[0].image?).to be_falsy
        end
      end
    end

    describe '#resource_url' do
      context 'when calling with thumb = false' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.jpg", content_type: "image/jpeg"}] }

        it 'returns original url' do
          expect(field.attachments[0].resource_url).not_to match(/representations/)
        end
      end

      context 'when attachment is an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.jpg", content_type: "image/jpeg"}] }

        it 'returns variant\'s url' do
          expect(field.attachments[0].resource_url(true)).to match(/representations/)
        end
      end

      context 'when attachment is not an image' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: "test.txt", content_type: "text/plain"}] }

        it 'returns original url' do
          expect(field.attachments[0].resource_url(true)).not_to match(/representations/)
        end
      end
    end
  end
end if defined?(ActiveStorage)
