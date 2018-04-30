require 'spec_helper'

describe 'dummy_app' do
  describe 'rails db:seed' do
    it 'loads seed data without errors' do
      cmd = "cd #{File.expand_path('../dummy_app', __FILE__)} && bundle install && bundle exec rails db:setup"
      db_seed_out = nil
      Bundler.with_clean_env do
        db_seed_out = `#{cmd}`
      end
      expect(db_seed_out).to end_with("\nSeeded 3 leagues, 6 divisions, 30 teams and 751 players\n")
    end
  end
end
