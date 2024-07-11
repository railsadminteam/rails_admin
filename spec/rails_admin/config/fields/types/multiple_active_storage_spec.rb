

require 'spec_helper'

if defined?(ActiveStorage)
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
      describe '#thumb_method' do
        let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.txt', content_type: 'text/plain'}] }
        subject { field.attachments[0] }

        it 'returns corresponding value which is to be passed to image_processing(ActiveStorage >= 6.0) or mini_magick(ActiveStorage 5.2)' do
          expect(subject.thumb_method).to eq(resize_to_limit: [100, 100])
        end
      end

      describe '#pretty_value' do
        subject { field.pretty_value }

        context 'when attachment is not an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.txt', content_type: 'text/plain'}] }

          it 'uses filename as link text' do
            expect(Nokogiri::HTML(subject).text).to eq 'test.txt'
          end
        end

        context 'when the field is an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.jpg', content_type: 'image/jpeg'}] }

          it 'shows thumbnail image with a link' do
            expect(Nokogiri::HTML(subject).css('img').attribute('src').value).to match(%r{rails/active_storage/representations})
            expect(Nokogiri::HTML(subject).css('a').attribute('href').value).to match(%r{rails/active_storage/blobs})
          end
        end
      end

      describe '#image?' do
        context 'when attachment is an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.jpg', content_type: 'image/jpeg'}] }

          it 'returns true' do
            expect(field.attachments[0].image?).to be_truthy
          end
        end

        context 'when attachment is not an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.txt', content_type: 'text/plain'}] }

          it 'returns false' do
            expect(field.attachments[0].image?).to be_falsy
          end
        end
      end

      describe '#resource_url' do
        context 'when calling with thumb = false' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.jpg', content_type: 'image/jpeg'}] }

          it 'returns original url' do
            expect(field.attachments[0].resource_url).not_to match(/representations/)
          end
        end

        context 'when attachment is an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.jpg', content_type: 'image/jpeg'}] }

          it 'returns variant\'s url' do
            expect(field.attachments[0].resource_url(true)).to match(/representations/)
          end
        end

        context 'when attachment is not an image' do
          let(:record) { FactoryBot.create :field_test, active_storage_assets: [{io: StringIO.new('dummy'), filename: 'test.txt', content_type: 'text/plain'}] }

          it 'returns original url' do
            expect(field.attachments[0].resource_url(true)).not_to match(/representations/)
          end
        end
      end
    end

    describe '#eager_load' do
      it 'points to associations to be eager-loaded' do
        expect(field.eager_load).to eq({active_storage_assets_attachments: :blob})
      end
    end

    describe '#direct' do
      let(:view) { double }
      let(:field) do
        RailsAdmin.config('FieldTest').fields.detect do |f|
          f.name == :active_storage_assets
        end.with(view: view)
      end
      before do
        allow(view).to receive_message_chain(:main_app, :rails_direct_uploads_url) { 'http://www.example.com/rails/active_storage/direct_uploads' }
      end

      context 'when false' do
        it "doesn't put the direct upload url in html_attributes" do
          expect(field.html_attributes[:data]&.[](:direct_upload_url)).to be_nil
        end
      end

      context 'when true' do
        before do
          RailsAdmin.config FieldTest do
            field(:active_storage_assets) { direct true }
          end
        end

        it 'puts the direct upload url in html_attributes' do
          expect(field.html_attributes[:data]&.[](:direct_upload_url)).to eq 'http://www.example.com/rails/active_storage/direct_uploads'
        end
      end
    end

    describe '#searchable' do
      it 'is false' do
        expect(field.searchable).to be false
      end
    end

    describe '#sortable' do
      it 'is false' do
        expect(field.sortable).to be false
      end
    end
  end
end
