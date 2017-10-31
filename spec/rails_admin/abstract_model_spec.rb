require 'spec_helper'

describe RailsAdmin::AbstractModel do
  describe '#to_s' do
    it 'returns model\'s name' do
      expect(RailsAdmin::AbstractModel.new(Cms::BasicPage).to_s).to eq Cms::BasicPage.to_s
    end
  end

  describe 'filters' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    context 'ActiveModel::ForbiddenAttributesProtection' do
      it 'is present' do
        @abstract_model.model.ancestors.collect(&:to_s).include?('ActiveModel::ForbiddenAttributesProtection')
      end
    end

    context 'on dates with :en locale' do
      before do
        [Date.new(2012, 1, 1), Date.new(2012, 1, 2), Date.new(2012, 1, 3), Date.new(2012, 1, 4)].each do |date|
          FactoryGirl.create(:field_test, date_field: date)
        end
      end

      it 'lists elements within outbound limits' do
        expect(@abstract_model.all(filters: {'date_field' => {'1' => {v: ['', 'January 02, 2012', 'January 03, 2012'], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'date_field' => {'1' => {v: ['', 'January 02, 2012', 'January 02, 2012'], o: 'between'}}}).count).to eq(1)
        expect(@abstract_model.all(filters: {'date_field' => {'1' => {v: ['', 'January 03, 2012', ''], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'date_field' => {'1' => {v: ['', '', 'January 02, 2012'], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'date_field' => {'1' => {v: ['January 02, 2012'], o: 'default'}}}).count).to eq(1)
      end
    end

    context 'on datetimes with :en locale' do
      before do
        I18n.locale = :en
        FactoryGirl.create(:field_test, datetime_field: Time.local(2012, 1, 1, 23, 59, 59))
        FactoryGirl.create(:field_test, datetime_field: Time.local(2012, 1, 2, 0, 0, 0))
        FactoryGirl.create(:field_test, datetime_field: Time.local(2012, 1, 3, 23, 59, 59))

        # TODO: Mongoid 3.0.0 mysteriously expands the range of inclusion slightly...
        if defined?(Mongoid) && Mongoid::VERSION >= '3.0.0'
          FactoryGirl.create(:field_test, datetime_field: Time.local(2012, 1, 4, 0, 0, 1))
        else
          FactoryGirl.create(:field_test, datetime_field: Time.local(2012, 1, 4, 0, 0, 0))
        end
      end

      it 'lists elements within outbound limits' do
        expect(@abstract_model.all(filters: {'datetime_field' => {'1' => {v: ['', 'January 02, 2012 12:00', 'January 03, 2012 12:00'], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'datetime_field' => {'1' => {v: ['', 'January 02, 2012 12:00', 'January 02, 2012 12:00'], o: 'between'}}}).count).to eq(1)
        expect(@abstract_model.all(filters: {'datetime_field' => {'1' => {v: ['', 'January 03, 2012 12:00', ''], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'datetime_field' => {'1' => {v: ['', '', 'January 02, 2012 12:00'], o: 'between'}}}).count).to eq(2)
        expect(@abstract_model.all(filters: {'datetime_field' => {'1' => {v: ['January 02, 2012 12:00'], o: 'default'}}}).count).to eq(1)
      end
    end

    if ::Rails.version >= '4.1'
      context "an abstract model with an string enum field" do
        before do
          @abstract_model = RailsAdmin::AbstractModel.new('Player')
        end

        before do
          FactoryGirl.create(:player, formation: :start)
          FactoryGirl.create(:player, formation: :substitute)
        end

        it "filters by enum values" do
          enum_value = 'start'
          expect(@abstract_model.all(filters: {'formation' => {'1' => {v: [enum_value], o: 'is'}}}).count).to eq(1)
        end
      end

      context "an abstract model with an integer enum field" do
        before do
          @abstract_model = RailsAdmin::AbstractModel.new('Team')
        end

        let!(:teams) do
          [
            FactoryGirl.create(:team , main_sponsor: 'no_sponsor'),
            FactoryGirl.create(:team , main_sponsor: 'food_factory'),
          ]
        end

        it "filters by enum values" do
          enum_value = 'food_factory'
          ENV['STOP_NOW'] = '1'
          scope = @abstract_model.all(filters: {'main_sponsor' => {'1' => {v: [enum_value], o: 'is'}}})
          expect(scope.count).to eq(1), "Teams (#{teams.map(&:id).join(" ,")}) All Teams #{Team.all.map(&:id).join(", ")} SQL: #{scope.to_sql}"
        end
      end
    end
  end

  context 'with Kaminari' do
    before do
      @paged = Player.page(1)
      Kaminari.config.page_method_name = :per_page_kaminari
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    after do
      Kaminari.config.page_method_name = :page
    end

    it "supports pagination when Kaminari's page_method_name is customized" do
      expect(Player).to receive(:per_page_kaminari).once.and_return(@paged)
      @abstract_model.all(sort: PK_COLUMN, page: 1, per: 2)
    end
  end

  describe 'each_associated_children' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @draft = FactoryGirl.build :draft
      @comments = FactoryGirl.build_list :comment, 2
      @player = FactoryGirl.build :player, draft: @draft, comments: @comments
    end

    it 'should return has_one and has_many associations with its children' do
      @abstract_model.each_associated_children(@player) do |association, children|
        expect(children).to eq case association.name
                               when :draft
                                 [@draft]
                               when :comments
                                 @comments
                               end
      end
    end
  end
end
