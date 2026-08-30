# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Enum do
  it_behaves_like 'a generic field type', :string_field, :enum

  subject { RailsAdmin.config(Team).field(:color) }

  describe "when object responds to '\#{method}_enum'" do
    before do
      allow_any_instance_of(Team).to receive(:color_enum).and_return(%w[blue green red])
      RailsAdmin.config Team do
        edit do
          field :color
        end
      end
    end

    it 'auto-detects enumeration' do
      is_expected.to be_a(RailsAdmin::Config::Fields::Types::Enum)
      is_expected.not_to be_multiple
      expect(subject.with(object: Team.new).enum).to eq %w[blue green red]
    end
  end

  describe "when class responds to '\#{method}_enum'" do
    before do
      allow(Team).to receive(:color_enum).and_return(%w[blue green red])
      Team.instance_eval do
        def color_enum
          %w[blue green red]
        end
      end
      RailsAdmin.config Team do
        edit do
          field :color
        end
      end
    end

    it 'auto-detects enumeration' do
      is_expected.to be_a(RailsAdmin::Config::Fields::Types::Enum)
      expect(subject.with(object: Team.new).enum).to eq %w[blue green red]
    end
  end

  describe "when only the class responds to '\#{method}_enum'" do
    before do
      Team.singleton_class.class_eval do
        def manager_enum
          %w[Alice Bob]
        end
      end
      RailsAdmin.config Team do
        list do
          field :manager, :enum
        end
      end
    end

    after do
      Team.singleton_class.send(:remove_method, :manager_enum)
    end

    let(:field) { RailsAdmin.config(Team).list.fields.detect { |f| f.name == :manager } }

    # The filters dropdown renders fields bound to a view but to no object,
    # so the enumeration has to resolve without one.
    it 'resolves the enumeration without a bound object' do
      expect(field.with(view: nil).enum).to eq %w[Alice Bob]
    end

    it 'builds filter options without a bound object' do
      expect { field.with(view: nil).filter_options }.not_to raise_error
    end
  end

  describe 'the enum instance method' do
    before do
      Team.class_eval do
        def color_list
          %w[blue green red]
        end
      end
      RailsAdmin.config Team do
        field :color, :enum do
          enum_method :color_list
        end
      end
    end

    after do
      Team.send(:remove_method, :color_list)
    end

    it 'allows configuration' do
      is_expected.to be_a(RailsAdmin::Config::Fields::Types::Enum)
      expect(subject.with(object: Team.new).enum).to eq %w[blue green red]
    end
  end

  describe 'the enum class method' do
    before do
      Team.instance_eval do
        def color_list
          %w[blue green red]
        end
      end
      RailsAdmin.config Team do
        field :color, :enum do
          enum_method :color_list
        end
      end
    end

    after do
      Team.instance_eval { undef :color_list }
    end

    it 'allows configuration' do
      is_expected.to be_a(RailsAdmin::Config::Fields::Types::Enum)
      expect(subject.with(object: Team.new).enum).to eq %w[blue green red]
    end
  end

  describe 'when overriding enum configuration' do
    before do
      Team.class_eval do
        def color_list
          %w[blue green red]
        end
      end
      RailsAdmin.config Team do
        field :color, :enum do
          enum_method :color_list
          enum do
            %w[yellow black]
          end
        end
      end
    end

    after do
      Team.send(:remove_method, :color_list)
    end

    it 'allows direct listing of enumeration options and override enum method' do
      is_expected.to be_a(RailsAdmin::Config::Fields::Types::Enum)
      expect(subject.with(object: Team.new).enum).to eq %w[yellow black]
    end
  end

  describe 'when serialize is enabled in ActiveRecord model', active_record: true do
    subject { RailsAdmin.config(TeamWithSerializedEnum).field(:color) }

    before do
      class TeamWithSerializedEnum < Team
        self.table_name = 'teams'
        if ActiveRecord.gem_version < Gem::Version.new('7.1')
          serialize :color
        else
          serialize :color, coder: JSON
        end
        def color_enum
          %w[blue green red]
        end
      end
      RailsAdmin.config do |c|
        c.included_models = [TeamWithSerializedEnum]
      end
    end

    it 'makes enumeration multi-selectable' do
      is_expected.to be_multiple
    end
  end

  describe 'when serialize is enabled in Mongoid model', mongoid: true do
    before do
      allow(Team).to receive(:color_enum).and_return(%w[blue green red])
      Team.instance_eval do
        field :color, type: Array
      end
    end

    after do
      Team.instance_eval do
        field :color, type: String
      end
    end

    it 'makes enumeration multi-selectable' do
      is_expected.to be_multiple
    end
  end
end
