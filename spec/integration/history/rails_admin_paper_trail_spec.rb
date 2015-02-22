require 'spec_helper'

describe 'RailsAdmin PaperTrail history', active_record: true do
  describe 'model history fetch' do
    before(:all) do
      RailsAdmin.config do |config|
        config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
      end
    end

    before(:each) do
      PaperTrail::Version.delete_all
      @model = RailsAdmin::AbstractModel.new('PaperTrailTest')
      @user = FactoryGirl.create :user
      @paper_trail_test = FactoryGirl.create :paper_trail_test
      with_versioning do
        PaperTrail.whodunnit = @user.id
        30.times do |i|
          @paper_trail_test.update!(name: "updated name #{i}")
        end
      end
    end

    it 'creates versions' do
      expect(PaperTrail::Version.count).to eq(30)
    end

    describe 'model history fetch with auditing adapter' do
      before(:all) do
        @adapter = RailsAdmin::Extensions::PaperTrail::AuditingAdapter.new(nil, 'User', 'PaperTrail::Version')
      end

      it 'fetches on page of history' do
        versions = @adapter.listing_for_model @model, nil, false, false, false, nil, 20
        expect(versions.total_count).to eq(30)
        expect(versions.count).to eq(20)
      end

      it 'respects RailsAdmin::Config.default_items_per_page' do
        RailsAdmin.config.default_items_per_page = 15
        versions = @adapter.listing_for_model @model, nil, false, false, false, nil
        expect(versions.total_count).to eq(30)
        expect(versions.count).to eq(15)
      end

      it 'sets correct next page' do
        versions = @adapter.listing_for_model @model, nil, false, false, false, 2, 10
        expect(versions.next_page).to eq(3)
      end

      describe 'returned version objects' do
        before(:each) do
          @padinated_listing = @adapter.listing_for_model @model, nil, false, false, false, nil
          @version = @padinated_listing.first
        end

        it '#username returns user email' do
          expect(@version.username).to eq(@user.email)
        end

        it '#message returns event' do
          expect(@version.message).to eq('update')
        end

        describe 'changed item attributes' do
          it '#item returns item.id' do
            expect(@version.item).to eq(@paper_trail_test.id)
          end

          it '#table returns item class name' do
            expect(@version.table.to_s).to eq('PaperTrailTest')
          end
        end

        context 'with Kaminari' do
          before do
            @paged = @adapter.listing_for_model @model, nil, false, false, false, nil
            Kaminari.config.page_method_name = :per_page_kaminari
          end

          after do
            Kaminari.config.page_method_name = :page
          end

          it "supports pagination when Kaminari's page_method_name is customized" do
            expect(PaperTrail::Version).to receive(:per_page_kaminari).twice.and_return(@paged)
            @adapter.listing_for_model @model, nil, false, false, false, nil
            @adapter.listing_for_object @model, @paper_trail_test, nil, false, false, false, nil
          end
        end
      end
    end
  end
end
