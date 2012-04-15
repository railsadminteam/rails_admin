require 'spec_helper'

describe RailsAdmin::AbstractModel do
  describe 'filters' do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    context 'on dates' do
      it 'lists elements within outbound limits' do
        date_format = I18n.t("admin.misc.filter_date_format", :default => I18n.t("admin.misc.filter_date_format", :locale => :en)).gsub('dd', '%d').gsub('mm', '%m').gsub('yy', '%Y')

        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/01/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/02/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/03/2012", date_format))
        FactoryGirl.create(:field_test, :date_field => Date.strptime("01/04/2012", date_format))
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count.should == 1
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count.should == 1

      end
    end

    context 'on datetimes' do
      it 'lists elements within outbound limits' do
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 1, 23, 59, 59))
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 2, 0, 0, 0))
        FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 3, 23, 59, 59))
        if defined?(Mongoid) && Mongoid::VERSION >= '3.0.0'
          # TODO: Mongoid 3.0.0 mysteriously expands the range of inclusion slightly...
          FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 4, 0, 0, 1))
        else
          FactoryGirl.create(:field_test, :datetime_field => Time.local(2012, 1, 4, 0, 0, 0))
        end
        @abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/02/2012"], :o => 'between' } } } ).count.should == 1
        @abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } ).count.should == 2
        @abstract_model.all(:filters => { "datetime_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } ).count.should == 1
      end
    end
  end
end
