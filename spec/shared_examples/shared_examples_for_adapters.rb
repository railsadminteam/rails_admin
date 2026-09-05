# frozen_string_literal: true

require 'spec_helper'

# Conformance suite shared by every adapter.
#
# It pins down the behavior that the ActiveRecord and Mongoid adapters currently
# agree on. It deliberately introduces no design change: freezing today's
# behavior is the whole point.
#
# Without it, a fix applied to one adapter never reaches the other and the two
# drift apart. That has already happened more than once:
#
#   - filter_scope guarded against unknown field names only in Mongoid, and only
#     ActiveRecord honoured the configured default search operator. Both were
#     found by this suite and are now settled in one place.
#   - WhereBuilder, composite primary keys and defined_enums exist only in
#     ActiveRecord
#
# Once the contract settles this should move to lib/rails_admin/testing/ so that
# out-of-tree adapters can simply say:
#
#   it_behaves_like 'a RailsAdmin adapter'
#
# Let definitions the including group must provide:
#
#   adapter_record_type       expected type of instances returned by #new / #get
#   adapter_property_type     expected type of #properties elements
#   adapter_association_type  expected type of #associations elements
#   adapter_missing_id        an id no record has
#
# Not part of the contract yet, because the two adapters need different APIs to
# observe them. They stay in the per-adapter suites until Phase 2 moves query
# building into a compiler:
#
#   - asserting that eager loading took effect (includes_values vs inclusions)
#   - the output of build_statement (SQL fragment vs Mongo selector)
#   - how a search across an association is carried out (join vs two-step lookup)
#   - handing a record to GlobalID / ActiveJob, which Mongoid does not support;
#     only "returns a raw instance" generalizes, so that is what is asserted here
RSpec.shared_examples 'a RailsAdmin adapter' do
  let(:model_class) { Player }
  let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }

  describe 'reflection' do
    it '#properties returns the adapter Property class' do
      expect(abstract_model.properties.first).to be_a_kind_of adapter_property_type
    end

    it '#associations returns the adapter Association class' do
      expect(abstract_model.associations.first).to be_a_kind_of adapter_association_type
    end

    it '#base_class returns the inheritance base class' do
      expect(RailsAdmin::AbstractModel.new(Hardball).base_class).to eq Ball
    end

    it '#primary_key is exposed' do
      expect(abstract_model.primary_key).to be_present
    end

    # Callers inside the gem ask in the plural so that a composite key needs no
    # special case, which only works if the plural is an array even when the key
    # has one column.
    it '#primary_keys is an array of symbols, whatever the key looks like' do
      expect(abstract_model.primary_keys).to be_an(Array)
      expect(abstract_model.primary_keys).to all(be_a(Symbol))
      expect(abstract_model.primary_keys).to eq Array(abstract_model.primary_key).collect(&:to_sym)
    end
  end

  describe 'data access' do
    let!(:players) { FactoryBot.create_list(:player, 3) }
    # Ids must be accepted as strings by every adapter: whatever arrives from a
    # URL parameter is a string, so this is a real requirement rather than a
    # convenience.
    let(:ids) { players.collect { |player| player.id.to_s } }

    describe '#new' do
      it 'returns an instance of the underlying model' do
        expect(abstract_model.new).to be_a(adapter_record_type)
      end
    end

    describe '#get' do
      it 'returns the record for a stringified id' do
        expect(abstract_model.get(ids.first)).to eq players.first
      end

      it 'returns nil when the id does not exist' do
        expect(abstract_model.get(adapter_missing_id)).to be_nil
      end

      # This is why the AbstractObject proxy had to go (#2847).
      #
      # case/when dispatches through Module#===, that is rb_obj_is_kind_of at the
      # C level, which method_missing forwarding cannot fake. Wrapping the record
      # in a proxy breaks here -- while #class is forwarded, so only the error
      # message keeps looking genuine. is_a? and instance_of? are ordinary method
      # calls and are forwarded too, so neither can be used for this check.
      it 'returns a genuine model instance, not a proxy' do
        record = abstract_model.get(ids.first)
        genuine =
          case record
          when model_class then true
          else false
          end
        expect(genuine).to be true
      end
    end

    describe '#first' do
      it 'returns one of the records' do
        expect(players).to include abstract_model.first
      end
    end

    describe '#count' do
      it 'returns the number of records' do
        expect(abstract_model.count).to eq players.count
      end
    end

    describe '#destroy' do
      it 'destroys multiple records' do
        abstract_model.destroy(players[0..1])
        expect(model_class.all.to_a).to match_array players[2..]
      end
    end

    describe '#all' do
      it 'works without options' do
        expect(abstract_model.all.to_a).to match_array players
      end

      it 'supports limiting' do
        expect(abstract_model.all(limit: 2).to_a.size).to eq 2
      end

      it 'supports retrieval by bulk_ids' do
        expect(abstract_model.all(bulk_ids: ids[0..1]).to_a).to match_array players[0..1]
      end

      # Both adapters order descending unless sort_reverse is given.
      it 'supports ordering by the primary key' do
        expect(abstract_model.all(sort: abstract_model.primary_key).to_a).to eq players.reverse
      end

      it 'supports reversing the order' do
        expect(abstract_model.all(sort: abstract_model.primary_key, sort_reverse: true).to_a).to eq players
      end

      it 'supports pagination' do
        expect(abstract_model.all(sort: abstract_model.primary_key, page: 1, per: 2).to_a).to eq players.reverse.first(2)
        expect(abstract_model.all(sort: abstract_model.primary_key, page: 2, per: 1).to_a).to eq [players[1]]
      end

      it 'supports querying' do
        expect(abstract_model.all(query: players[1].name).to_a).to eq players[1..1]
      end

      it 'supports filtering' do
        expect(abstract_model.all(filters: {'name' => {'0000' => {o: 'is', v: players[1].name}}}).to_a).to eq players[1..1]
      end

      it 'ignores a filter on a non-existent field' do
        expect { abstract_model.all(filters: {'dummy' => {'0000' => {o: 'is', v: players[1].name}}}).to_a }.
          not_to raise_error
      end

      # The field types that offer no operator in the filter UI submit none, so
      # the configured default is what those filters end up using.
      it 'falls back to the configured default search operator for a filter with no operator' do
        RailsAdmin.config { |config| config.default_search_operator = 'starts_with' }

        expect(abstract_model.all(filters: {'name' => {'0000' => {v: players[1].name}}}).to_a).to eq players[1..1]
        expect(abstract_model.all(filters: {'name' => {'0000' => {v: players[1].name[1..]}}}).to_a).to be_empty
      end
    end

    describe '#where' do
      it 'returns filtered results' do
        expect(abstract_model.where(name: players.first.name).to_a).to eq [players.first]
      end
    end
  end
end
