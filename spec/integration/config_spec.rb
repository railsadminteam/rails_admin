require 'spec_helper'

describe RailsAdmin::Config do
  subject { page }

  describe ".statistics" do
    describe "set to true(default)" do
      it 'should show record count bars' do
        RailsAdmin::Config.model(Player).abstract_model.should_receive(:count).and_return(0)
        visit dashboard_path
        body.should have_content('Site administration')
        body.should have_content('Records')
      end
    end

    describe "set to false" do
      before do
        RailsAdmin.config do |c|
          c.actions do
            dashboard do
              statistics false
            end
          end
        end
      end

      it 'should hide record count bars' do
        RailsAdmin::Config.model(Player).abstract_model.should_not_receive(:count)
        visit dashboard_path
        body.should have_content('Site administration')
        body.should_not have_content('Records')
      end
    end
  end
end
