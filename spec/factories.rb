# coding: utf-8

FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    sequence(:number) { |n| n }
    sequence(:position) { |n| "Position #{n}" }
  end

  factory :draft do
    date 1.week.ago
    sequence(:round)
    sequence(:pick)
    sequence(:overall)
    sequence(:college) {|n| "College #{n}"}
    association :team
    association :player
  end

  factory :team do
    sequence(:division_id)
    sequence(:name) { |n| "Team #{n}" }
    sequence(:manager) { |n| "Manager #{n}" }
    sequence(:founded)
    sequence(:wins)
    sequence(:losses)
    sequence(:win_percentage)
  end

  factory :league do
    sequence(:name) { |n| "League #{n}" }
  end

  factory :division do
    sequence(:custom_league_id)
    sequence(:name) { |n| "Division #{n}" }
  end

  factory :fan do
    sequence(:name) { |n| "Fan #{n}" }
  end

  factory :user do
    sequence(:email) { |n| "username_#{n}@example.com" }
    sequence(:password) { |n| "password" }
  end

  factory :field_test do
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

  factory :ball do
    color(%W(red blue green yellow purple brown black white).sample)
  end

  factory :hardball do
    color('blue')
  end

  factory :image do
    file File.open(Rails.root.join('public', 'robots.txt'))
  end
end
