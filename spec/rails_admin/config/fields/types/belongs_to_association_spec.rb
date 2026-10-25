# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::BelongsToAssociation do
  it_behaves_like 'a generic field type', :integer_field, :belongs_to_association

  let(:field) { RailsAdmin.config(Player).fields.detect { |f| f.name == :team } }

  # The form posts the association as nested attributes once it has a nested
  # form, which is no column to search or sort by.
  context 'when the association has a nested form' do
    before { Player.accepts_nested_attributes_for :team }
    after { Player.nested_attributes_options.delete(:team) }

    describe '#searchable' do
      it 'targets the foreign key' do
        expect(field.searchable).to eq [:name, {Player => :team_id}]
      end
    end

    describe '#sortable' do
      it 'targets the foreign key when the associated label is not an attribute' do
        RailsAdmin.config(Team) do
          object_label_method :team_without_label_method
        end
        expect(field.sortable).to eq('players' => :team_id)
      end
    end
  end

  context 'with a composite foreign key', active_record: true, composite_primary_keys: true do
    let(:field) { RailsAdmin.config(FavoritePlayer).fields.detect { |f| f.name == :fanship } }

    describe '#searchable' do
      it 'targets every column the key is made of' do
        expect(field.searchable).to eq [{FavoritePlayer => :fan_id}, {FavoritePlayer => :team_id}]
      end
    end

    describe '#sortable' do
      it 'is false, since a sort takes one column' do
        expect(field.sortable).to be false
      end
    end
  end
end
