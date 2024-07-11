

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Association do
  describe '#pretty_value' do
    let(:player) { FactoryBot.create(:player, name: '<br />', team: FactoryBot.create(:team)) }
    let(:field) { RailsAdmin.config('Team').fields.detect { |f| f.name == :players } }
    let(:view) { ActionView::Base.empty }
    subject { field.with(object: player.team, view: view).pretty_value }

    context 'when the link is disabled' do
      let(:view) { ActionView::Base.empty.tap { |d| allow(d).to receive(:action).and_return(nil) } }

      it 'does not expose non-HTML-escaped string' do
        is_expected.to be_html_safe
        is_expected.to eq '&lt;br /&gt;'
      end
    end

    context 'when the value is empty' do
      let(:team) { FactoryBot.build :team }
      subject { field.with(object: team, view: view).pretty_value }

      it "returns '-' to show emptiness" do
        is_expected.to eq '-'
      end
    end
  end

  describe '#dynamic_scope_relationships' do
    let(:player) { FactoryBot.create(:player, team: FactoryBot.create(:team)) }
    let(:field) { RailsAdmin.config('Draft').fields.detect { |f| f.name == :player } }

    it 'returns the relationship of fields in this model and in the associated model' do
      RailsAdmin.config Draft do
        field :team
        field :player do
          dynamically_scope_by :team
        end
      end
      expect(field.dynamic_scope_relationships).to eq({team_id: :team})
    end

    it 'accepts Array' do
      RailsAdmin.config Draft do
        field :team
        field :notes
        field :player do
          dynamically_scope_by %i[team notes]
        end
      end
      expect(field.dynamic_scope_relationships).to eq({team_id: :team, notes: :notes})
    end

    it 'accepts Hash' do
      RailsAdmin.config Draft do
        field :round
        field :player do
          dynamically_scope_by({round: :number})
        end
      end
      expect(field.dynamic_scope_relationships).to eq({round: :number})
    end

    it 'accepts mixture of Array and Hash' do
      RailsAdmin.config Draft do
        field :team
        field :round
        field :player do
          dynamically_scope_by [:team, {round: :number}]
        end
      end
      expect(field.dynamic_scope_relationships).to eq({team_id: :team, round: :number})
    end

    it 'raises error if the field does not exist in this model' do
      RailsAdmin.config Draft do
        field :player do
          dynamically_scope_by :team
        end
      end
      expect { field.dynamic_scope_relationships }.to raise_error "Field 'team' was given for #dynamically_scope_by but not found in 'Draft'"
    end

    it 'raises error if the field does not exist in the associated model' do
      RailsAdmin.config Player do
        field :name
      end
      RailsAdmin.config Draft do
        field :team
        field :player do
          dynamically_scope_by :team
        end
      end
      expect { field.dynamic_scope_relationships }.to raise_error "Field 'team' was given for #dynamically_scope_by but not found in 'Player'"
    end

    it 'raises error if the target field is not filterable' do
      RailsAdmin.config Player do
        field :name
        field :team do
          filterable false
        end
      end
      RailsAdmin.config Draft do
        field :team
        field :player do
          dynamically_scope_by :team
        end
      end
      expect { field.dynamic_scope_relationships }.to raise_error "Field 'team' in 'Player' can't be used for dynamic scoping because it's not filterable"
    end
  end

  describe '#removable?', active_record: true do
    context 'with non-nullable foreign key' do
      let(:field) { RailsAdmin.config('FieldTest').fields.detect { |f| f.name == :nested_field_tests } }
      it 'is false' do
        expect(field.removable?).to be false
      end
    end

    context 'with nullable foreign key' do
      let(:field) { RailsAdmin.config('Team').fields.detect { |f| f.name == :players } }
      it 'is true' do
        expect(field.removable?).to be true
      end
    end

    context 'with polymorphic has_many' do
      let(:field) { RailsAdmin.config('Player').fields.detect { |f| f.name == :comments } }
      it 'does not break' do
        expect(field.removable?).to be true
      end
    end

    context 'with has_many through' do
      before do
        class TeamWithHasManyThrough < Team
          has_many :drafts
          has_many :draft_players, through: :drafts, source: :player
        end
      end
      let(:field) { RailsAdmin.config('TeamWithHasManyThrough').fields.detect { |f| f.name == :draft_players } }
      it 'does not break' do
        expect(field.removable?).to be true
      end
    end
  end

  describe '#value' do
    context 'when using `system` as the association name' do
      before do
        class System < Tableless; end

        class BelongsToSystem < Tableless
          column :system_id, :integer
          belongs_to :system
        end
      end
      let(:record) { BelongsToSystem.new(system: System.new) }
      let(:field) { RailsAdmin.config(BelongsToSystem).fields.detect { |f| f.name == :system } }
      subject { field.with(object: record).value }

      it 'does not break' do
        expect(subject).to be_a_kind_of System
      end
    end
  end
end
