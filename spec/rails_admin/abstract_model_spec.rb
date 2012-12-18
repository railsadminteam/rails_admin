require 'spec_helper'

describe RailsAdmin::AbstractModel do

  describe "#to_s" do
    it 'returns model\'s name' do
      expect(RailsAdmin::AbstractModel.new(Cms::BasicPage).to_s).to eq Cms::BasicPage.to_s
    end
  end

  describe "filters" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    context "ActiveModel::ForbiddenAttributesProtection" do
      it "is present" do
        @abstract_model.model.ancestors.map(&:to_s).include?('ActiveModel::ForbiddenAttributesProtection')
      end
    end

    context "on dates" do
      it "lists elements within outbound limits" do
        date_format = I18n.t("admin.misc.filter_date_format", :default => I18n.t("admin.misc.filter_date_format", :locale => :en)).gsub('dd', '%d').gsub('mm', '%m').gsub('yy', '%Y')

        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/01/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/02/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/03/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/04/2012", date_format))
        expect(@abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count).to eq(1)
        expect(@abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count).to eq(1)

      end
    end

    context "on datetimes" do
      it "lists elements within outbound limits" do
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 1, 23, 59, 59))
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 2, 0, 0, 0))
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 3, 23, 59, 59))
        if defined?(Mongoid) && Mongoid::VERSION >= '3.0.0'
          # TODO: Mongoid 3.0.0 mysteriously expands the range of inclusion slightly...
          FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 4, 0, 0, 1))
        else
          FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 4, 0, 0, 0))
        end
        expect(@abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count).to eq(1)
        expect(@abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count).to eq(2)
        expect(@abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count).to eq(1)
      end
    end
  end

  context "with Kaminari" do
    before do
      Kaminari.config.page_method_name = :per_page_kaminari
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @paged = Player.page(1)
    end

    after do
      Kaminari.config.page_method_name = :page
    end

    it "supports pagination when Kaminari's page_method_name is customized" do
      Player.should_receive(:per_page_kaminari).once.and_return(@paged)
      @abstract_model.all(:sort => PK_COLUMN, :page => 1, :per => 2)
    end
  end
end
