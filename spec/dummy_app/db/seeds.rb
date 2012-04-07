require 'mlb'

AgnosticUser     = RailsAdmin::AbstractModel.new(User)
AgnosticLeague   = RailsAdmin::AbstractModel.new(League)
AgnosticDivision = RailsAdmin::AbstractModel.new(Division)
AgnosticTeam     = RailsAdmin::AbstractModel.new(Team)
AgnosticPlayer   = RailsAdmin::AbstractModel.new(Player)

AgnosticUser.new(:email => 'username@example.com', :password => 'password', :password_confirmation => 'password').save

MLB::Team.all.each do |mlb_team|
  unless league = AgnosticLeague.where(:name => mlb_team.league).first
    league = AgnosticLeague.new(:name => mlb_team.league)
    league.save
  end
  unless division = AgnosticDivision.where(:name => mlb_team.division).first
    division = AgnosticDivision.new(:name => mlb_team.division, :league => league)
    division.save
  end
  unless team = AgnosticTeam.where(:name => mlb_team.name).first
    team = AgnosticTeam.new(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division)
    team.save
  end
  mlb_team.players.reject{|player| player.number.nil?}.each do |player|
    AgnosticPlayer.new(:name => player.name, :number => player.number, :position => player.position, :team => team).save
  end
end

puts "Seeded #{AgnosticLeague.count} leagues, #{AgnosticDivision.count} divisions, #{AgnosticTeam.count} teams and #{AgnosticPlayer.count} players"
