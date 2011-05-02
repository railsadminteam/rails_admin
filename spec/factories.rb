Factory.define :player do |f|
  f.sequence(:name) { |n| "Player #{n}" }
  f.sequence(:number) { |n| n }
end

Factory.define :draft do |f|
  f.date 1.week.ago
  f.round rand(100000)
  f.pick rand(100000)
  f.overall rand(100000)
  f.association :team
  f.association :player
end

Factory.define :team do |f|
  f.division_id rand(99999)
  f.sequence(:name) { |n| "Team #{n}" }
  f.sequence(:manager) { |n| "Manager #{n}" }
  f.founded 1869 + rand(130)
  f.wins(wins = rand(163))
  f.losses 162 - wins
  f.win_percentage("%.3f" % (wins.to_f / 162).to_f)
end

Factory.define :league do |f|
  f.sequence(:name) { |n| "League #{n}" }
end

Factory.define :division do |f|
  f.sequence(:name) { |n| "Division #{n}" }
  f.association :league
end

Factory.define :fan do |f|
  f.sequence(:name) { |n| "Fan #{n}" }
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "username_#{n}@example.com" }
  f.sequence(:password) { |n| "password" }
end

Factory.define :comment do |f|
  f.association :commentable
  f.content <<-EOF
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
    quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
    consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
    proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  EOF
end
