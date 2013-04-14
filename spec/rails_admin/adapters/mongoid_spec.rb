require 'spec_helper'
require 'timecop'

describe "RailsAdmin::Adapters::Mongoid", :mongoid => true do
  describe "#associations" do
    before :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents

      class MongoBlog
        include Mongoid::Document
        has_many :mongo_posts
        has_many :mongo_comments, :as => :commentable
        belongs_to :librarian, :polymorphic => true
        field :mongo_blog_id
      end

      class MongoPost
        include Mongoid::Document
        belongs_to :mongo_blog
        has_and_belongs_to_many :mongo_categories
        has_many :mongo_comments, :as => :commentable
        embeds_one :mongo_note
        accepts_nested_attributes_for :mongo_note
      end

      class MongoCategory
        include Mongoid::Document
        has_and_belongs_to_many :mongo_posts
        belongs_to :librarian, :polymorphic => true
      end

      class MongoUser
        include Mongoid::Document
        has_one :mongo_profile
        has_many :mongo_categories, :as => :librarian

        embeds_many :mongo_notes
        accepts_nested_attributes_for :mongo_notes
        field :name, :type => String
        field :message, :type => String
        field :short_text, :type => String

        validates :short_text, :length => {:maximum => 255}
      end

      class MongoProfile
        include Mongoid::Document
        belongs_to :mongo_user
        has_many :mongo_blogs, :as => :librarian
      end

      class MongoComment
        include Mongoid::Document
        belongs_to :commentable, :polymorphic => true
      end

      class MongoNote
        include Mongoid::Document
        embedded_in :mongo_post
        embedded_in :mongo_user
      end

      @blog     = RailsAdmin::AbstractModel.new MongoBlog
      @post     = RailsAdmin::AbstractModel.new MongoPost
      @category = RailsAdmin::AbstractModel.new MongoCategory
      @user     = RailsAdmin::AbstractModel.new MongoUser
      @profile  = RailsAdmin::AbstractModel.new MongoProfile
      @comment  = RailsAdmin::AbstractModel.new MongoComment
    end

    after :all do
      RailsAdmin::AbstractModel.reset_polymorphic_parents
    end

    it "lists associations" do
      expect(@post.associations.map{|a| a[:name]}).to match_array [:mongo_blog, :mongo_categories, :mongo_comments, :mongo_note]
    end

    it "reads correct and know types in [:belongs_to, :has_and_belongs_to_many, :has_many, :has_one]" do
      expect((@post.associations + @blog.associations + @user.associations).map{|a|a[:type].to_s}.uniq).to match_array ['belongs_to', 'has_and_belongs_to_many', 'has_many', 'has_one']
    end

    it "has correct parameter of belongs_to association" do
      param = @post.associations.find{|a| a[:name] == :mongo_blog}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_blog,
        :pretty_name => "Mongo blog",
        :type => :belongs_to,
        :foreign_key => :mongo_blog_id,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoBlog)
    end

    it "has correct parameter of has_many association" do
      param = @blog.associations.find{|a| a[:name] == :mongo_posts}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_posts,
        :pretty_name => "Mongo posts",
        :type => :has_many,
        :foreign_key => :mongo_blog_id,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoPost)
      expect(@post.properties.find{|f| f[:name] == :mongo_blog_id}[:type]).to eq(:bson_object_id)
    end

    it "does not confuse foreign_key column which belongs to associated model" do
      expect(@blog.properties.find{|f| f[:name] == :mongo_blog_id}[:type]).to eq(:string)
    end

    it "has correct parameter of has_and_belongs_to_many association" do
      param = @post.associations.find{|a| a[:name] == :mongo_categories}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_categories,
        :pretty_name => "Mongo categories",
        :type => :has_and_belongs_to_many,
        :foreign_key => :mongo_category_ids,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoCategory)
    end

    it "has correct parameter of polymorphic belongs_to association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
      param = @comment.associations.find{|a| a[:name] == :commentable}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :commentable,
        :pretty_name => "Commentable",
        :type => :belongs_to,
        :foreign_key => :commentable_id,
        :foreign_type => :commentable_type,
        :foreign_inverse_of => (Mongoid::VERSION >= '3.0.0' ? :commentable_field : nil),
        :as => nil,
        :polymorphic => true,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq([MongoBlog, MongoPost])
    end

    it "has correct parameter of polymorphic inverse has_many association" do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
      param = @blog.associations.find{|a| a[:name] == :mongo_comments}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_comments,
        :pretty_name => "Mongo comments",
        :type => :has_many,
        :foreign_key => :commentable_id,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => :commentable,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => nil
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoComment)
    end

    it 'has correct opposite model lookup for polymorphic associations' do
      RailsAdmin::Config.stub!(:models_pool).and_return(["MongoBlog", "MongoPost", "MongoCategory", "MongoUser", "MongoProfile", "MongoComment"])
      expect(@category.associations.find{|a| a[:name] == :librarian}[:model_proc].call).to eq [MongoUser]
      expect(@blog.associations.find{|a| a[:name] == :librarian}[:model_proc].call).to eq [MongoProfile]
    end

    it "has correct parameter of embeds_one association" do
      param = @post.associations.find{|a| a[:name] == :mongo_note}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_note,
        :pretty_name => "Mongo note",
        :type => :has_one,
        :foreign_key => nil,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => {:allow_destroy => false, :update_only => false}
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoNote)
    end

    it "has correct parameter of embeds_many association" do
      param = @user.associations.find{|a| a[:name] == :mongo_notes}
      expect(param.reject{|k, v| [:primary_key_proc, :model_proc].include? k }).to eq({
        :name => :mongo_notes,
        :pretty_name => "Mongo notes",
        :type => :has_many,
        :foreign_key => nil,
        :foreign_type => nil,
        :foreign_inverse_of => nil,
        :as => nil,
        :polymorphic => false,
        :inverse_of => nil,
        :read_only => nil,
        :nested_form => {:allow_destroy => false, :update_only => false}
      })
      expect(param[:primary_key_proc].call).to eq(:_id)
      expect(param[:model_proc].call).to eq(MongoNote)
    end

    it "raises error when embeds_* is used without accepts_nested_attributes_for" do
      class MongoEmbedsOne
        include Mongoid::Document
        embeds_one :mongo_embedded
      end

      class MongoEmbedsMany
        include Mongoid::Document
        embeds_many :mongo_embeddeds
      end

      class MongoEmbedded
        include Mongoid::Document
        embedded_in :mongo_embeds_one
        embedded_in :mongo_embeds_many
      end

      class MongoRecursivelyEmbedsOne
        include Mongoid::Document
        recursively_embeds_one
      end

      class MongoRecursivelyEmbedsMany
        include Mongoid::Document
        recursively_embeds_many
      end

      expect(lambda{ RailsAdmin::AbstractModel.new(MongoEmbedsOne).associations }).to raise_error(RuntimeError,
        "Embbeded association without accepts_nested_attributes_for can't be handled by RailsAdmin,\nbecause embedded model doesn't have top-level access.\nPlease add `accepts_nested_attributes_for :mongo_embedded' line to `MongoEmbedsOne' model.\n"
      )
      expect(lambda{ RailsAdmin::AbstractModel.new(MongoEmbedsMany).associations }).to raise_error(RuntimeError,
        "Embbeded association without accepts_nested_attributes_for can't be handled by RailsAdmin,\nbecause embedded model doesn't have top-level access.\nPlease add `accepts_nested_attributes_for :mongo_embeddeds' line to `MongoEmbedsMany' model.\n"
      )
      expect(lambda{ RailsAdmin::AbstractModel.new(MongoRecursivelyEmbedsOne).associations }).not_to raise_error
      expect(lambda{ RailsAdmin::AbstractModel.new(MongoRecursivelyEmbedsMany).associations }).not_to raise_error
    end

    it "works with inherited embeds_many model" do
      class MongoEmbedsParent
        include Mongoid::Document
        embeds_many :mongo_embeddeds
        accepts_nested_attributes_for :mongo_embeddeds
      end

      class MongoEmbedded
        include Mongoid::Document
        embedded_in :mongo_embeds_many
      end

      class MongoEmbedsChild < MongoEmbedsParent; end

      expect(lambda{ RailsAdmin::AbstractModel.new(MongoEmbedsChild).associations }).not_to raise_error
    end
  end

  describe "#properties" do
    before :all do
      @abstract_model = RailsAdmin::AbstractModel.new(FieldTest)
    end

    it "maps Mongoid column types to RA types" do
      expect(@abstract_model.properties.select{|p| %w(_id array_field big_decimal_field
        boolean_field bson_object_id_field bson_binary_field date_field datetime_field
        time_with_zone_field default_field float_field hash_field integer_field name
        object_field range_field short_text string_field subject symbol_field text_field
        time_field title).include? p[:name].to_s}).to match_array [
        { :name => :_id,
          :pretty_name => "Id",
          :nullable? => true,
          :serial? => true,
          :type => :bson_object_id,
          :length => nil },
        { :name => :array_field,
          :pretty_name => "Array field",
          :nullable? => true,
          :serial? => false,
          :type => :serialized,
          :length => nil },
        { :name => :big_decimal_field,
          :pretty_name => "Big decimal field",
          :nullable? => true,
          :serial? => false,
          :type => :decimal,
          :length => nil },
        { :name => :boolean_field,
          :pretty_name => "Boolean field",
          :nullable? => true,
          :serial? => false,
          :type => :boolean,
          :length => nil },
        { :name => :bson_object_id_field,
          :pretty_name => "Bson object id field",
          :nullable? => true,
          :serial? => false,
          :type => :bson_object_id,
          :length => nil },
        { :name => :date_field,
          :pretty_name => "Date field",
          :nullable? => true,
          :serial? => false,
          :type => :date,
          :length => nil },
        { :name => :datetime_field,
          :pretty_name => "Datetime field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :time_with_zone_field,
          :pretty_name => "Time with zone field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :default_field,
          :pretty_name => "Default field",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :float_field,
          :pretty_name => "Float field",
          :nullable? => true,
          :serial? => false,
          :type => :float,
          :length => nil },
        { :name => :hash_field,
          :pretty_name => "Hash field",
          :nullable? => true,
          :serial? => false,
          :type => :serialized,
          :length => nil },
        { :name => :integer_field,
          :pretty_name => "Integer field",
          :nullable? => true,
          :serial? => false,
          :type => :integer,
          :length => nil },
        { :name => :name,
          :pretty_name => "Name",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :object_field,
          :pretty_name => "Object field",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :short_text,
          :pretty_name => "Short text",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :string_field,
          :pretty_name => "String field",
          :nullable? => true,
          :serial? => false,
          :type => :text,
          :length => nil },
        { :name => :subject,
          :pretty_name => "Subject",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :symbol_field,
          :pretty_name => "Symbol field",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 },
        { :name => :text_field,
          :pretty_name => "Text field",
          :nullable? => true,
          :serial? => false,
          :type => :text,
          :length => nil },
        { :name => :time_field,
          :pretty_name => "Time field",
          :nullable? => true,
          :serial? => false,
          :type => :datetime,
          :length => nil },
        { :name => :title,
          :pretty_name => "Title",
          :nullable? => true,
          :serial? => false,
          :type => :string,
          :length => 255 }
      ]
    end

    it "detects validation length properly" do
      class LengthValiated
        include Mongoid::Document
        field :text, :type => String
        validates :text, :length => {:maximum => 50}
      end
      expect(RailsAdmin::AbstractModel.new('LengthValiated').send(:length_validation_lookup, :text)).to eq(50)
    end

    it "does not cause problem with custom validators" do
      class MyCustomValidator < ActiveModel::Validator
        def validate(r); end
      end
      class CustomValiated
        include Mongoid::Document
        field :text, :type => String
        validates_with MyCustomValidator
      end
      expect(lambda{ RailsAdmin::AbstractModel.new('CustomValiated').send(:length_validation_lookup, :text) }).not_to raise_error
    end
  end

  describe "data access method" do
    before do
      @players = FactoryGirl.create_list(:player, 3)
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#new returns instance of AbstractObject" do
      expect(@abstract_model.new.object).to be_instance_of(Player)
    end

    it "#get returns instance of AbstractObject" do
      expect(@abstract_model.get(@players.first.id.to_s).object).to eq(@players.first)
    end

    it "#get returns nil when id does not exist" do
      expect(@abstract_model.get('4f4f0824dcf2315093000000')).to be_nil
    end

    it "#first returns a player" do
      expect(@players).to include @abstract_model.first
    end

    it "#count returns count of items" do
      expect(@abstract_model.count).to eq(@players.count)
    end

    it "#destroy destroys multiple items" do
      @abstract_model.destroy(@players[0..1])
      expect(Player.all).to eq(@players[2..2])
    end

    it "#where returns filtered results" do
      expect(@abstract_model.where(:name => @players.first.name).to_a).to eq([@players.first])
    end

    describe "#all" do
      it "works without options" do
        expect(@abstract_model.all.to_a).to match_array @players
      end

      it "supports eager loading" do
        expect(@abstract_model.all(:include => :team).inclusions.map{|i| i.class_name}).to eq(["Team"])
      end

      it "supports limiting" do
        expect(@abstract_model.all(:limit => 2).to_a).to have(2).items
      end

      it "supports retrieval by bulk_ids" do
        expect(@abstract_model.all(:bulk_ids => @players[0..1].map{|player| player.id.to_s }).to_a).to match_array @players[0..1]
      end

      it "supports pagination" do
        expect(@abstract_model.all(:sort => 'players._id', :page => 2, :per => 1).to_a).to eq(@players[1..1])
        # To prevent RSpec matcher to call Mongoid::Criteria#== method,
        # (we want to test equality of query result, not of Mongoid criteria)
        # to_a is added to invoke Mongoid query
      end

      it "supports ordering" do
        expect(@abstract_model.all(:sort => 'players._id', :sort_reverse => true).to_a).to eq(@players.sort)
        expect(@abstract_model.all(:sort => 'players._id', :sort_reverse => false).to_a).to eq(@players.sort.reverse)
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => @players[1].name)).to eq(@players[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"name" => {"0000" => {:o => "is", :v => @players[1].name}}})).to eq(@players[1..1])
      end

      it "ignores non-existent field name on filtering" do
        expect(lambda{ @abstract_model.all(:filters => {"dummy" => {"0000" => {:o => "is", :v => @players[1].name}}}) }).not_to raise_error
      end
    end
  end

  describe "searching on association" do
    describe "whose type is belongs_to" do
      before do
        RailsAdmin.config Player do
          field :team do
            queryable true
          end
        end
        @players = FactoryGirl.create_list(:player, 3)
        @team = FactoryGirl.create :team, :name => 'foobar'
        @team.players << @players[1]
        @abstract_model = RailsAdmin::AbstractModel.new('Player')
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => 'foobar').to_a).to eq(@players[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"team" => {"0000" => {:o => "is", :v => 'foobar'}}}).to_a).to eq(@players[1..1])
      end
    end

    describe "whose type is has_many" do
      before do
        RailsAdmin.config Team do
          field :players do
            queryable true
            searchable :all
          end
        end
        @teams = FactoryGirl.create_list(:team, 3)
        @players = [{:team => @teams[1]},
                     {:team => @teams[1], :name => 'foobar'},
                     {:team => @teams[2]}].map{|h| FactoryGirl.create :player, h}
        @abstract_model = RailsAdmin::AbstractModel.new('Team')
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => 'foobar').to_a).to eq(@teams[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"players" => {"0000" => {:o => "is", :v => 'foobar'}}}).to_a).to eq(@teams[1..1])
      end
    end

    describe "whose type is has_and_belongs_to_many" do
      before do
        RailsAdmin.config Team do
          field :fans do
            queryable true
            searchable :all
          end
        end
        @teams = FactoryGirl.create_list(:team, 3)
        @fans = [{}, {:name => 'foobar'}, {}].map{|h| FactoryGirl.create :fan, h}
        @teams[1].fans = [@fans[0], @fans[1]]
        @teams[2].fans << @fans[2]
        @abstract_model = RailsAdmin::AbstractModel.new('Team')
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => 'foobar').to_a).to eq(@teams[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"fans" => {"0000" => {:o => "is", :v => 'foobar'}}}).to_a).to eq(@teams[1..1])
      end
    end

    describe "whose type is embedded has_many" do
      before do
        RailsAdmin.config FieldTest do
          field :embeds do
            queryable true
            searchable :all
          end
        end
        @field_tests = FactoryGirl.create_list(:field_test, 3)
        @field_tests[0].embeds.create :name => 'foo'
        @field_tests[1].embeds.create :name => 'bar'
        @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
      end

      it "supports querying" do
        expect(@abstract_model.all(:query => 'bar').to_a).to eq(@field_tests[1..1])
      end

      it "supports filtering" do
        expect(@abstract_model.all(:filters => {"embeds" => {"0000" => {:o => "is", :v => 'bar'}}}).to_a).to eq(@field_tests[1..1])
      end
    end
  end

  describe "#query_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @players = [{}, {:name => 'Many foos'}, {:position => 'foo shortage'}].
        map{|h| FactoryGirl.create :player, h}
    end

    it "makes conrrect query" do
      expect(@abstract_model.all(:query => "foo").to_a).to match_array @players[1..2]
    end
  end

  describe "#filter_conditions" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
      @team = FactoryGirl.create :team, :name => 'king of bar'
      @players = [{}, {:team => @team}, {:name => 'Many foos', :team => @team}, {:name => 'Great foo'}].
        map{|h| FactoryGirl.create :player, h}
    end

    it "makes conrrect query" do
      expect(@abstract_model.all(:filters  =>
        {"name" => {"0000" => {:o => "like", :v => "foo"}},
         "team" => {"0001" => {:o => "like", :v => "bar"}}}
      )).to eq([@players[2]])
    end
  end

  describe "#build_statement" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
    end

    it "ignores '_discard' operator or value" do
      [["_discard", ""], ["", "_discard"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to be_nil
      end
    end

    it "supports '_blank' operator" do
      [["_blank", ""], ["", "_blank"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => {"$in" => [nil, ""]}})
      end
    end

    it "supports '_present' operator" do
      [["_present", ""], ["", "_present"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => {"$nin" => [nil, ""]}})
      end
    end

    it "supports '_null' operator" do
      [["_null", ""], ["", "_null"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => nil})
      end
    end

    it "supports '_not_null' operator" do
      [["_not_null", ""], ["", "_not_null"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => {"$ne" => nil}})
      end
    end

    it "supports '_empty' operator" do
      [["_empty", ""], ["", "_empty"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => ""})
      end
    end

    it "supports '_not_empty' operator" do
      [["_not_empty", ""], ["", "_not_empty"]].each do |value, operator|
        expect(@abstract_model.send(:build_statement, :name, :string, value, operator)).to eq({:name => {"$ne" => ""}})
      end
    end

    it "supports boolean type query" do
      ['false', 'f', '0'].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq({:field => false})
      end
      ['true', 't', '1'].each do |value|
        expect(@abstract_model.send(:build_statement, :field, :boolean, value, nil)).to eq({:field => true})
      end
      expect(@abstract_model.send(:build_statement, :field, :boolean, 'word', nil)).to be_nil
    end

    it "supports integer type query" do
      expect(@abstract_model.send(:build_statement, :field, :integer, "1", nil)).to eq({:field => 1})
      expect(@abstract_model.send(:build_statement, :field, :integer, 'word', nil)).to be_nil
    end

    it "supports integer type range query" do
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['2', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '3', ''], 'between')).to eq({:field => {"$gte" => 3}})
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', '', '5'], 'between')).to eq({:field => {"$lte" => 5}})
      expect(@abstract_model.send(:build_statement, :field, :integer, [''  , '10', '20'], 'between')).to eq({:field => {"$gte" => 10, "$lte" => 20}})
      expect(@abstract_model.send(:build_statement, :field, :integer, ['15', '10', '20'], 'between')).to eq({:field => {"$gte" => 10, "$lte" => 20}})
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :integer, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it "supports both decimal and float type queries" do
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1", nil)).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1"   , 'default')).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, "1.1"   , 'between')).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['6.1', ''  , ''  ], 'default')).to eq({:field => 6.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['7.1', '10.1', ''  ], 'default')).to eq({:field => 7.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['8.1', ''  , '20.1'], 'default')).to eq({:field => 8.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['9.1', '10.1', '20.1'], 'default')).to eq({:field => 9.1})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '3.1', ''], 'between')).to eq({:field => {"$gte" => 3.1}})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', '', '5.1'], 'between')).to eq({:field => {"$lte" => 5.1}})
      expect(@abstract_model.send(:build_statement, :field, :decimal, [''  , '10.1', '20.1'], 'between')).to eq({:field => {"$gte" => 10.1, "$lte" => 20.1}})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['15.1', '10.1', '20.1'], 'between')).to eq({:field => {"$gte" => 10.1, "$lte" => 20.1}})
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :decimal, ['', 'word3', 'word4'], 'between')).to be_nil

      expect(@abstract_model.send(:build_statement, :field, :float, "1.1", nil)).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, "1.1"   , 'default')).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'default')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, "1.1"   , 'between')).to eq({:field => 1.1})
      expect(@abstract_model.send(:build_statement, :field, :float, 'word', 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['6.1', ''  , ''  ], 'default')).to eq({:field => 6.1})
      expect(@abstract_model.send(:build_statement, :field, :float, ['7.1', '10.1', ''  ], 'default')).to eq({:field => 7.1})
      expect(@abstract_model.send(:build_statement, :field, :float, ['8.1', ''  , '20.1'], 'default')).to eq({:field => 8.1})
      expect(@abstract_model.send(:build_statement, :field, :float, ['9.1', '10.1', '20.1'], 'default')).to eq({:field => 9.1})
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['2.1', '', ''], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '3.1', ''], 'between')).to eq({:field => {"$gte" => 3.1}})
      expect(@abstract_model.send(:build_statement, :field, :float, ['', '', '5.1'], 'between')).to eq({:field => {"$lte" => 5.1}})
      expect(@abstract_model.send(:build_statement, :field, :float, [''  , '10.1', '20.1'], 'between')).to eq({:field => {"$gte" => 10.1, "$lte" => 20.1}})
      expect(@abstract_model.send(:build_statement, :field, :float, ['15.1', '10.1', '20.1'], 'between')).to eq({:field => {"$gte" => 10.1, "$lte" => 20.1}})
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word1', ''     ], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', ''     , 'word2'], 'between')).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :float, ['', 'word3', 'word4'], 'between')).to be_nil
    end

    it "supports string type query" do
      expect(@abstract_model.send(:build_statement, :field, :string, "", nil)).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "was")).to be_nil
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "default")).to eq({:field => /foo/i})
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "like")).to eq({:field => /foo/i})
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "starts_with")).to eq({:field => /^foo/i})
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "ends_with")).to eq({:field => /foo$/i})
      expect(@abstract_model.send(:build_statement, :field, :string, "foo", "is")).to eq({:field => 'foo'})
    end

    it "supports date type query" do
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } })).to eq({"$and" => [{"date_field" => {"$gte" => Date.new(2012,1,2), "$lte" => Date.new(2012,1,3)}}]})
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } )).to eq({"$and" => [{"date_field" => {"$gte" => Date.new(2012,1,3)}}]})
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } )).to eq({"$and" => [{"date_field" => {"$lte" => Date.new(2012,1,2)}}]})
      expect(@abstract_model.send(:filter_conditions, { "date_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } )).to eq({"$and" => [{"date_field" => {"$gte" => Date.new(2012,1,2), "$lte" => Date.new(2012,1,2)}}]})
    end

    it "supports datetime type query" do
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/02/2012", "01/03/2012"], :o => 'between' } } } )).to eq({"$and" => [{"datetime_field" => {"$gte" => Time.local(2012,1,2), "$lte" => Time.local(2012,1,3).end_of_day}}]})
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "01/03/2012", ""], :o => 'between' } } } )).to eq({"$and" => [{"datetime_field" => {"$gte" => Time.local(2012,1,3)}}]})
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["", "", "01/02/2012"], :o => 'between' } } } )).to eq({"$and" => [{"datetime_field" => {"$lte" => Time.local(2012,1,2).end_of_day}}]})
      expect(@abstract_model.send(:filter_conditions, { "datetime_field" => { "1" => { :v => ["01/02/2012"], :o => 'default' } } } )).to eq({"$and" => [{"datetime_field" => {"$gte" => Time.local(2012,1,2), "$lte" => Time.local(2012,1,2).end_of_day}}]})
    end

    it "supports enum type query" do
      expect(@abstract_model.send(:build_statement, :field, :enum, "1", nil)).to eq({:field => {"$in" => ["1"]}})
    end
  end

  describe "model attribute method" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('Player')
    end

    it "#scoped returns relation object" do
      expect(@abstract_model.scoped).to be_instance_of(Mongoid::Criteria)
    end

    it "#table_name works" do
      expect(@abstract_model.table_name).to eq('players')
    end
  end

  describe "serialization" do
    before do
      @abstract_model = RailsAdmin::AbstractModel.new('FieldTest')
      @controller = RailsAdmin::MainController.new
    end

    it "accepts array value" do
      params = HashWithIndifferentAccess.new({:array_field => '[1, 3]'})
      @controller.send(:sanitize_params_for!, 'create', @abstract_model.config, params)
      expect(params[:array_field]).to eq([1, 3])
    end

    it "accepts hash value" do
      params = HashWithIndifferentAccess.new({:hash_field => '{a: 1, b: 3}'})
      @controller.send(:sanitize_params_for!, 'create', @abstract_model.config, params)
      expect(params[:hash_field]).to eq({"a" => 1, "b" => 3})
    end
  end
end
