require 'rails_admin/abstract_model'
require 'active_record'

module RailsAdmin

  class ExtraTasks
    def self.populateDatabase
      self.require_model

      max_history_times = 20
      history_months = 24

      current_month = Time.now.month
      current_year = Time.now.year

      history_months.times do |t|
        history_entries = rand(max_history_times)

        computed_date = t.month.ago

        action_type = rand(3) + 1

        history_entries.times do |t|
          History.create(:action => action_type,
                         :month => computed_date.month,
                         :year => computed_date.year,
                         :user_id => 1, :table => "Posts", :other => "something interesting!")
        end
      end

    end

    def self.require_model
      @models = []
      model_path = __FILE__
      model_path = model_path.split("/")[0..-5].join("/")
      model_path += "/app/models/history.rb"
      require model_path

      self.set_connection
    end

    def self.set_connection
      dbconfig = YAML::load(File.open(Rails.root.join("config/database.yml")))
      ActiveRecord::Base.establish_connection(dbconfig["development"])
    end

  end
end
