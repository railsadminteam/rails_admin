FactoryGirl.define do
  %w[team manager division league].each do |type|
    sequence :"#{type}_name" do |n|
      "#{type.capitalize} #{n}"
    end
  end
  
  
  factory :team do
    league_id rand(99999)
    division_id rand(99999)
    name Factory.next(:team_name)
    manager Factory.next(:manager_name)
    founded 1869 + rand(130)
    wins (wins = rand(163)) 
    losses 162 - wins
    win_percentage ("%.3f" % (wins.to_f / 162).to_f)
  end
  
  factory :league do
    name Factory.next(:league_name)
  end
  
  factory :division do
    name Factory.next(:division_name)
    association :league
  end
end