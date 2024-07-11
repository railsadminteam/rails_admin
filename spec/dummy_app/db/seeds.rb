

require 'mlb'

user_model     = RailsAdmin::AbstractModel.new(User)
league_model   = RailsAdmin::AbstractModel.new(League)
division_model = RailsAdmin::AbstractModel.new(Division)
team_model     = RailsAdmin::AbstractModel.new(Team)
player_model   = RailsAdmin::AbstractModel.new(Player)

user_model.new(email: 'username@example.com', password: 'password', password_confirmation: 'password').save

# mlb gem depends on Google Freebase API by default, which is dead.
connection = Faraday.new('https://raw.githubusercontent.com') do |conn|
  conn.use FaradayMiddleware::ParseJson
  conn.adapter Faraday.default_adapter
end
results = connection.get('/sferik/mlb/e5b9384fc388f34ec5baca291343864135dcb0fe/cache/teams.json').body

MLB::Team.send(:results_to_team, results).each do |mlb_team|
  league = league_model.where(name: mlb_team.league).first
  unless league
    league = league_model.model.new(name: mlb_team.league)
    league.save!
  end
  division = division_model.where(name: mlb_team.division).first
  unless division
    division = division_model.model.new(name: mlb_team.division, league: league)
    division.save!
  end
  team = team_model.where(name: mlb_team.name).first
  unless team
    team = team_model.model.new(name: mlb_team.name, logo_url: mlb_team.logo_url, manager: mlb_team.manager || 'None', ballpark: mlb_team.ballpark, mascot: mlb_team.mascot, founded: mlb_team.founded, wins: mlb_team.wins, losses: mlb_team.losses, win_percentage: format('%.3f', (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, division: division)
    team.save!
  end
  mlb_team.players.reject { |player| player.number.nil? }.each do |player|
    player_model.model.new(name: player.name, number: player.number, position: player.positions.first, team: team).save
  end
end

puts "Seeded #{league_model.count} leagues, #{division_model.count} divisions, #{team_model.count} teams and #{player_model.count} players"
