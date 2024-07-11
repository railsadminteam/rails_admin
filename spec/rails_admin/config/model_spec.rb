

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Model do
  describe '#excluded?' do
    before do
      RailsAdmin.config do |config|
        config.included_models = [Comment]
      end
    end

    it 'returns false when included, true otherwise' do
      allow(RailsAdmin::AbstractModel).to receive(:all).and_call_original

      player_config = RailsAdmin.config(Player)
      expect(player_config.excluded?).to be_truthy
      expect(RailsAdmin::AbstractModel).to have_received(:all).once
      # Calling a second time uses the cached value.
      expect(player_config.excluded?).to be_truthy
      expect(RailsAdmin::AbstractModel).to have_received(:all).once

      comment_config = RailsAdmin.config(Comment)
      expect(comment_config.excluded?).to be_falsey
      expect(RailsAdmin::AbstractModel).to have_received(:all).twice
      # Calling a second time uses the cached value.
      expect(comment_config.excluded?).to be_falsey
      expect(RailsAdmin::AbstractModel).to have_received(:all).twice
    end
  end

  describe '#object_label' do
    before do
      RailsAdmin.config(Comment) do
        object_label_method :content
      end
    end

    it 'sends object_label_method to binding[:object]' do
      c = Comment.new(content: 'test')
      expect(RailsAdmin.config(Comment).with(object: c).object_label).to eq('test')
    end

    context 'when the object_label_method is blank' do
      it 'uses the rails admin default' do
        c = Comment.create(content: '', id: '1')
        expect(RailsAdmin.config(Comment).with(object: c).object_label).to eq('Comment #1')
      end
    end
  end

  describe '#object_label_method' do
    it 'is first of Config.label_methods if found as a column on model, or :rails_admin_default_object_label_method' do
      expect(RailsAdmin.config(Comment).object_label_method).to eq(:rails_admin_default_object_label_method)
      expect(RailsAdmin.config(Division).object_label_method).to eq(:name)
    end
  end

  describe '#label' do
    it 'is pretty' do
      expect(RailsAdmin.config(Comment).label).to eq('Comment')
    end
  end

  describe '#label_plural' do
    it 'is pretty' do
      expect(RailsAdmin.config(Comment).label_plural).to eq('Comments')
    end

    context 'when using i18n as label source', skip_mongoid: true do
      around do |example|
        I18n.config.available_locales = I18n.config.available_locales + [:xx]
        I18n.backend.class.send(:include, I18n::Backend::Pluralization)
        I18n.backend.store_translations :xx,
                                        activerecord: {
                                          models: {
                                            comment: {
                                              one: 'one', two: 'two', other: 'other'
                                            },
                                          },
                                        }

        I18n.locale = :xx

        example.run

        I18n.locale = :en
        I18n.config.available_locales = I18n.config.available_locales - [:xx]
      end

      context 'and the locale uses a specific pluralization rule' do
        before do
          I18n.backend.store_translations :xx,
                                          i18n: {
                                            plural: {
                                              rule: ->(count) do
                                                case count
                                                when 0
                                                  :zero
                                                when 1
                                                  :one
                                                when 2
                                                  :two
                                                else
                                                  :other
                                                end
                                              end,
                                            },
                                          }
        end

        it 'always uses :other as pluralization key' do
          expect(RailsAdmin.config(Comment).label_plural).to eq('other')
        end
      end
    end
  end

  describe '#weight' do
    it 'is 0' do
      expect(RailsAdmin.config(Comment).weight).to eq(0)
    end
  end

  describe '#parent' do
    it 'is nil for ActiveRecord::Base inherited models' do
      expect(RailsAdmin.config(Comment).parent).to be_nil
    end

    it 'is parent model otherwise' do
      expect(RailsAdmin.config(Hardball).parent).to eq(Ball)
    end
  end

  describe '#navigation_label' do
    it 'is nil if parent module is Object' do
      expect(RailsAdmin.config(Comment).navigation_label).to be_nil
    end

    it 'is parent module otherwise' do
      expect(RailsAdmin.config(Cms::BasicPage).navigation_label).to eq('Cms')
    end
  end

  describe '#last_created_at', active_record: true do
    let!(:teams) do
      [FactoryBot.create(:team, created_at: 1.day.ago), FactoryBot.create(:team, created_at: 2.days.ago)]
    end
    before do
      RailsAdmin.config(Team) do
        last_created_at { abstract_model.model.maximum(:created_at) }
      end
    end

    it 'allow customization' do
      expect(RailsAdmin.config(Team).last_created_at.to_date).to eq 1.day.ago.to_date
    end
  end
end
