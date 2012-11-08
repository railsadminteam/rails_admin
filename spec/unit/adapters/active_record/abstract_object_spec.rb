require 'spec_helper'

describe "RailsAdmin::Adapters::ActiveRecord::AbstractObject", :active_record => true do
  describe "proxy" do
    let(:object) { mock("object") }
    let(:abstract_object) { RailsAdmin::Adapters::ActiveRecord::AbstractObject.new(object) }

    it "acts like a proxy" do
      object.should_receive(:method_call)
      abstract_object.method_call
    end
  end

  describe "create" do
    let(:player) { Player.new }
    let(:object) { RailsAdmin::Adapters::ActiveRecord::AbstractObject.new player }
    let(:name) { "Stefan Kiszonka" }
    let(:number) { 87 }
    let(:position) { "Fifth baseman" }
    let(:suspended) { true }

    describe "a record without associations" do
      before do
        object.set_attributes({ :name => name, :number => number, :position => position, :suspended => suspended, :team_id => nil })
      end

      it "creates a Player with given attributes" do
        expect(object.save).to be_true

        player.reload
        expect(player.name).to eq(name)
        expect(player.number).to eq(number)
        expect(player.position).to eq(position)
        expect(player.suspended).to be_false
        expect(player.draft).to be_nil
        expect(player.team).to be_nil
      end
    end

    describe "a record with protected attributes and has_one association" do
      let(:draft) { FactoryGirl.create(:draft) }
      let(:number) { draft.player.number + 1 } # to avoid collision

      before do
        object.set_attributes({ :name => name, :number => number, :position => position, :suspended => suspended, :team_id => nil, :draft_id => draft.id })
      end

      it "creates a Player with given attributes" do
        expect(object.save).to be_true

        player.reload
        expect(player.name).to eq(name)
        expect(player.number).to eq(number)
        expect(player.position).to eq(position)
        expect(player.suspended).to be_false
        expect(player.draft).to eq(draft.reload)
        expect(player.team).to be_nil
      end
    end

    describe "a record with has_many associations" do
      let(:league) { League.new }
      let(:object) { RailsAdmin::Adapters::ActiveRecord::AbstractObject.new league }
      let(:name) { "Awesome League" }
      let(:teams) { [FactoryGirl.create(:team)] }
      let(:divisions) { [Division.create!(:name => 'div 1', :league => League.create!(:name => 'north')), Division.create!(:name => 'div 2', :league => League.create!(:name => 'south'))] }

      before do
        object.set_attributes({ :name  => name, :division_ids => divisions.map(&:id) })
      end

      it "creates a League with given attributes and associations" do
        expect(object.save).to be_true
        league.reload
        expect(league.name).to eq(name)
        expect(league.divisions).to eq(divisions)
      end
    end
  end

  describe "update" do
    describe "a record with protected attributes and has_one association" do
      let(:name) { "Stefan Koza" }
      let(:suspended) { true }
      let(:player) { FactoryGirl.create(:player, :suspended => true, :name => name, :draft => FactoryGirl.create(:draft)) }
      let(:object) { RailsAdmin::Adapters::ActiveRecord::AbstractObject.new player }
      let(:new_team) { FactoryGirl.create(:team) }
      let(:new_suspended) { false }
      let(:new_draft) { nil }
      let(:new_number) { player.number + 29 }

      before do
        object.set_attributes({ :number => new_number, :team_id => new_team.id, :suspended => new_suspended, :draft_id => new_draft })
        object.save
      end

      it "updates a record and associations" do
        object.reload
        expect(object.number).to eq(new_number)
        expect(object.name).to eq(name)
        expect(object.draft).to be_nil
        expect(object.suspended).to be_true
        expect(object.team).to eq(new_team)
      end
    end
  end

  describe "destroy" do
    let(:player) { FactoryGirl.create(:player) }
    let(:object) { RailsAdmin::Adapters::ActiveRecord::AbstractObject.new player }

    before do
      object.destroy
    end

    it "deletes the record" do
      expect(Player.exists?(player.id)).to be_false
    end
  end

  describe "object_label_method" do
    it "is configurable" do
      RailsAdmin.config League do
        object_label_method { :custom_name }
      end

      @league = FactoryGirl.create :league

      expect(RailsAdmin.config('League').with(:object => @league).object_label).to eq("League '#{@league.name}'")
    end
  end
end
