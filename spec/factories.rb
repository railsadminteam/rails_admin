# coding: utf-8

FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    sequence(:number) { |n| n }
    sequence(:position) { |n| "Position #{n}" }
  end

  factory :draft do
    date 1.week.ago
    round rand(100000)
    pick rand(100000)
    overall rand(100000)
    sequence(:college) {|n| "College #{n}"}
    association :team
    association :player
  end

  factory :team do
    division_id rand(99999)
    sequence(:name) { |n| "Team #{n}" }
    sequence(:manager) { |n| "Manager #{n}" }
    founded 1869 + rand(130)
    wins(wins = rand(163))
    losses 162 - wins
    win_percentage("%.3f" % (wins.to_f / 162).to_f)
  end

  factory :league do
    sequence(:name) { |n| "League #{n}" }
  end

  factory :division do
    sequence(:name) { |n| "Division #{n}" }
    association :league
  end

  factory :fan do
    sequence(:name) { |n| "Fan #{n}" }
  end

  factory :user do
    sequence(:email) { |n| "username_#{n}@example.com" }
    sequence(:password) { |n| "password" }
  end

  factory :comment do
    sequence(:content) do |n| <<-EOF
        Lorém --#{n}-- ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
        proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      EOF
    end
  end
end
