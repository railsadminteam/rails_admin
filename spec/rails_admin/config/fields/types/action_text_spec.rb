# frozen_string_literal: true

require 'spec_helper'

if defined?(ActionText)
  RSpec.describe RailsAdmin::Config::Fields::Types::ActionText do
    it_behaves_like 'a generic field type', :action_text_field

    it_behaves_like 'a string-like field type', :action_text_field

    describe 'asset locations' do
      before do
        RailsAdmin.config FieldTest do
          edit do
            field :action_text_field
          end
        end
      end

      let(:field) { RailsAdmin.config('FieldTest').edit.fields.detect { |f| f.name == :action_text_field } }

      it 'serves the UMD build of the pinned Trix' do
        expect(field.js_location).to eq "https://unpkg.com/trix@#{RailsAdmin::Version.npm_dependency('trix')}/dist/trix.umd.min.js"
      end

      it 'serves the stylesheet of the pinned Trix' do
        expect(field.css_location).to eq "https://unpkg.com/trix@#{RailsAdmin::Version.npm_dependency('trix')}/dist/trix.css"
      end

      context 'when pinned to the Trix 1.x line' do
        it 'serves the file name that line ships' do
          field.version '1.3.5'
          expect(field.js_location).to eq 'https://unpkg.com/trix@1.3.5/dist/trix.js'
        end

        it 'serves the stylesheet, which both lines name the same' do
          field.version '1.3.5'
          expect(field.css_location).to eq 'https://unpkg.com/trix@1.3.5/dist/trix.css'
        end
      end
    end
  end
end
