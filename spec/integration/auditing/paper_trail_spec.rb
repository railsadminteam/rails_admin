

require 'spec_helper'

RSpec.describe 'RailsAdmin PaperTrail auditing', active_record: true do
  before(:each) do
    RailsAdmin.config do |config|
      config.audit_with :paper_trail
    end
  end

  shared_examples :paper_on_object_creation do
    describe 'on object creation', type: :request do
      subject { page }
      before do
        @user = FactoryBot.create :user
        RailsAdmin::Config.authenticate_with { warden.authenticate! scope: :user }
        RailsAdmin::Config.current_user_method(&:current_user)
        login_as @user
        with_versioning do
          visit new_path(model_name: paper_model_name)
          fill_in paper_field_name, with: 'Jackie Robinson'
          click_button 'Save'
          @object = RailsAdmin::AbstractModel.new(paper_class_name).first
        end
      end

      it 'records a version' do
        expect(@object.versions.size).to eq 1
        expect(@object.versions.first.whodunnit).to eq @user.id.to_s
      end
    end
  end

  shared_examples :paper_history do
    describe 'model history fetch' do
      before(:each) do
        PaperTrail::Version.delete_all
        @model = RailsAdmin::AbstractModel.new(paper_class_name)
        @user = FactoryBot.create :user
        @paper_trail_test = FactoryBot.create(paper_factory)
        with_versioning do
          # `PaperTrail.whodunnit` deprecated in PT 9, will be removed in 10.
          # Use `PaperTrail.request.whodunnit` instead.
          if PaperTrail.respond_to?(:request)
            PaperTrail.request.whodunnit = @user.id
          else
            PaperTrail.whodunnit = @user.id
          end
          30.times do |i|
            @paper_trail_test.update!(name: "updated name #{i}")
          end
        end
      end

      it 'creates versions' do
        expect(paper_class_name.constantize.version_class_name.constantize.count).to eq(30)
      end

      describe 'model history fetch with auditing adapter' do
        before(:all) do
          @adapter = RailsAdmin::Extensions::PaperTrail::AuditingAdapter.new(nil)
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

        it 'can fetch all history' do
          versions = @adapter.listing_for_model @model, nil, false, false, true, nil, 20
          expect(versions.total_count).to eq(30)
          expect(versions.count).to eq(30)
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
              expect(@version.table.to_s).to eq(@model.model.base_class.name)
            end
          end

          context 'with Kaminari' do
            before do
              Kaminari.config.page_method_name = :per_page_kaminari
            end

            after do
              Kaminari.config.page_method_name = :page
            end

            let(:paginated_array) { Kaminari::PaginatableArray.new.page('1') }

            it "supports pagination when Kaminari's page_method_name is customized" do
              expect(PaperTrail::Version).to receive(:per_page_kaminari).twice.and_return(@padinated_listing)
              allow(Kaminari).to receive(:paginate_array).and_return(paginated_array)
              expect(paginated_array).to receive(:per_page_kaminari).twice.and_return(paginated_array)
              @adapter.listing_for_model @model, nil, false, false, false, nil
              @adapter.listing_for_object @model, @paper_trail_test, nil, false, false, false, nil
            end

            it "does not break when Kaminari's page_method_name is not applied to Kaminari::PaginatableArray" do
              expect(PaperTrail::Version).to receive(:per_page_kaminari).twice.and_return(@padinated_listing)
              allow(Kaminari).to receive(:paginate_array).and_return(paginated_array)
              allow(paginated_array).to receive(:respond_to).with(:per_page_kaminari).and_return(false)
              expect(paginated_array).to receive(:page).twice.and_return(paginated_array)
              @adapter.listing_for_model @model, nil, false, false, false, nil
              @adapter.listing_for_object @model, @paper_trail_test, nil, false, false, false, nil
            end
          end
        end
      end
    end
  end

  context 'with a normal PaperTrail model' do
    let(:paper_class_name) { 'PaperTrailTest' }
    let(:paper_factory) { :paper_trail_test }

    it_behaves_like :paper_on_object_creation do
      let(:paper_model_name) { 'paper_trail_test' }
      let(:paper_field_name) { 'paper_trail_test[name]' }
    end

    it_behaves_like :paper_history
  end

  context 'with a subclassed PaperTrail model' do
    let(:paper_class_name) { 'PaperTrailTestSubclass' }
    let(:paper_factory) { :paper_trail_test_subclass }

    it_behaves_like :paper_on_object_creation do
      let(:paper_model_name) { 'paper_trail_test_subclass' }
      let(:paper_field_name) { 'paper_trail_test_subclass[name]' }
    end

    it_behaves_like :paper_history
  end

  context 'with a namespaced PaperTrail model' do
    let(:paper_class_name) { 'PaperTrailTest::SubclassInNamespace' }
    let(:paper_factory) { :paper_trail_test_subclass_in_namespace }

    it_behaves_like :paper_on_object_creation do
      let(:paper_model_name) { 'paper_trail_test~subclass_in_namespace' }
      let(:paper_field_name) { 'paper_trail_test_subclass_in_namespace[name]' }
    end

    it_behaves_like :paper_history
  end

  context 'with a PaperTrail model with custom version association name' do
    let(:paper_class_name) { 'PaperTrailTestWithCustomAssociation' }
    let(:paper_factory) { :paper_trail_test_with_custom_association }

    it_behaves_like :paper_history
  end
end
