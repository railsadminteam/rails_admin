# frozen_string_literal: true

require 'mlb'

user_model     = RailsAdmin::AbstractModel.new(User)
league_model   = RailsAdmin::AbstractModel.new(League)
division_model = RailsAdmin::AbstractModel.new(Division)
team_model     = RailsAdmin::AbstractModel.new(Team)
player_model   = RailsAdmin::AbstractModel.new(Player)

user_model.new(email: 'username@example.com', password: 'password', password_confirmation: 'password').save

MLB::Teams.all(season: Time.now.year).each do |mlb_team|
  league = league_model.where(name: mlb_team.league.name).first
  unless league
    league = league_model.model.new(name: mlb_team.league.name)
    league.save!
  end
  division = division_model.where(name: mlb_team.division.name).first
  unless division
    division = division_model.model.new(name: mlb_team.division.name, league: league)
    division.save!
  end
  team = team_model.where(name: mlb_team.name).first
  unless team
    team = team_model.model.new(name: mlb_team.name, logo_url: mlb_team.link, manager: 'None', ballpark: mlb_team.venue.name, founded: mlb_team.first_year_of_play, wins: 0, losses: 0, win_percentage: 0.0, division: division)
    team.save!
  end
  mlb_team.roster.reject { |roster| roster.jersey_number.nil? }.each do |roster|
    player_model.model.new(name: roster.player.full_name, number: roster.jersey_number, position: roster.position.name, team: team).save
  end
end

puts "Seeded #{league_model.count} leagues, #{division_model.count} divisions, #{team_model.count} teams and #{player_model.count} players"
