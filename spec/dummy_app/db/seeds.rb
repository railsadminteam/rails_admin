require 'mlb'

user_model     = RailsAdmin::AbstractModel.new(User)
league_model   = RailsAdmin::AbstractModel.new(League)
division_model = RailsAdmin::AbstractModel.new(Division)
team_model     = RailsAdmin::AbstractModel.new(Team)
player_model   = RailsAdmin::AbstractModel.new(Player)

user_model.new(:email => 'username@example.com', :password => 'password', :password_confirmation => 'password').save

MLB::Team.all.each do |mlb_team|
  unless league = league_model.where(:name => mlb_team.league).first
    league = league_model.model.new(:name => mlb_team.league)
    league.save!
  end
  unless division = division_model.where(:name => mlb_team.division).first
    division = division_model.model.new(:name => mlb_team.division, :league => league)
    division.save!
  end
  unless team = team_model.where(:name => mlb_team.name).first
    team = team_model.model.new(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division)
    team.save!
  end
  mlb_team.players.reject{|player| player.number.nil?}.each do |player|
    player_model.model.new(:name => player.name, :number => player.number, :position => player.position, :team => team).save
  end
end

puts "Seeded #{league_model.count} leagues, #{division_model.count} divisions, #{team_model.count} teams and #{player_model.count} players"
