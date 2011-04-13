require 'mlb'

User.create(:email => 'username@example.com', :password => 'password', :password_confirmation => 'password')

MLB::Team.all.each do |mlb_team|
  unless league = RailsAdmin::AbstractModel.new("League").first(:conditions => ["name = ?", mlb_team.league])
    league = RailsAdmin::AbstractModel.new("League").create(:name => mlb_team.league)
  end
  unless division = RailsAdmin::AbstractModel.new("Division").first(:conditions => ["name = ?", mlb_team.division])
    division = RailsAdmin::AbstractModel.new("Division").create(:name => mlb_team.division, :league => league)
  end
  unless team = RailsAdmin::AbstractModel.new("Team").first(:conditions => ["name = ?", mlb_team.name])
    team = RailsAdmin::AbstractModel.new("Team").create(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division)
  end
  mlb_team.players.reject{|player| player.number.nil?}.each do |player|
    RailsAdmin::AbstractModel.new("Player").create(:name => player.name, :number => player.number, :position => player.position, :team => team)
  end
end
