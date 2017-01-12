appraise "rails-4.0" do
  gem 'rails', '~> 4.0.0'
  gem 'sass-rails', '~> 4.0.3'
  gem 'devise', '>= 3.2'
  gem 'test-unit'
  gem 'capybara', '>= 0.8', group: :test
  gem 'kaminari', '~> 0.14'

  group :active_record do
    gem 'paper_trail', '~> 5.0'
  end

  group :mongoid do
    gem 'mongoid', '~> 4.0'
    gem 'kaminari-mongoid', '~> 0.1'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', '>= 0.0.1', platforms: [:ruby_21, :ruby_22, :ruby_23]
  end

  platforms :ruby_21, :ruby_22, :ruby_23 do
    gem 'refile', '~> 0.5', require: 'refile/rails'
    gem 'refile-mini_magick', '>= 0.1.0'
  end
end

appraise "rails-4.1" do
  gem 'rails', '~> 4.1.0'
  gem 'devise', '>= 3.2'
  gem 'capybara', '>= 0.8', group: :test

  group :active_record do
    gem 'paper_trail', '>= 5.0'
  end

  group :mongoid do
    gem 'mongoid', '~> 4.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', '>= 0.0.1', platforms: [:ruby_21, :ruby_22, :ruby_23]
  end

  platforms :ruby_21, :ruby_22, :ruby_23 do
    gem 'refile', '~> 0.5', require: 'refile/rails'
    gem 'refile-mini_magick', '>= 0.1.0'
  end
end

appraise "rails-4.2" do
  gem 'rails', '~> 4.2.0'
  gem 'sass-rails', '~> 5.0'
  gem 'devise', '>= 3.4'
  gem 'capybara', '>= 0.8', group: :test

  group :active_record do
    gem 'paper_trail', '>= 5.0'
  end

  group :mongoid do
    gem 'mongoid', '~> 4.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', '>= 0.0.1', platforms: [:ruby_21, :ruby_22, :ruby_23]
  end

  platforms :ruby_21, :ruby_22, :ruby_23 do
    gem 'refile', '~> 0.5', require: 'refile/rails'
    gem 'refile-mini_magick', '>= 0.1.0'
  end
end

appraise "rails-5.0" do
  gem 'rails', '~> 5.0.0'
  gem 'sass-rails', '~> 5.0'
  gem 'devise', '~> 4.0'

  group :active_record do
    gem 'paper_trail', '>= 5.0'
  end

  group :mongoid do
    gem 'mongoid', '>= 6.0.0.beta'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
  end
end
