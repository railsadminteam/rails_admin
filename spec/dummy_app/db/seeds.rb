require 'mlb'

User.create(:email => 'username@example.com', :password => 'password', :password_confirmation => 'password')

MLB::Team.all.each do |mlb_team|
  unless league = League.where(:name => mlb_team.league).first
    league = League.create(:name => mlb_team.league)
  end
  unless division = Division.where(:name => mlb_team.division).first
    division = Division.create(:name => mlb_team.division, :league => league)
  end
  unless team = Team.where(:name => mlb_team.name).first
    team = Team.create(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division)
  end
  mlb_team.players.reject{|player| player.number.nil?}.each do |player|
    Player.create(:name => player.name, :number => player.number, :position => player.position, :team => team)
  end
end
