# frozen_string_literal: true

appraise 'rails-6.0' do
  gem 'rails', '~> 6.0.0'
  gem 'sassc-rails', '~> 2.1'
  gem 'devise', '~> 4.7'

  group :test do
    gem 'cancancan', '~> 3.0'
    gem 'kt-paperclip'
    gem 'pundit', '~> 2.1.0'
    gem 'rspec-rails', '>= 4.0.0.beta2'
    gem 'shrine', '~> 3.0'
  end

  group :active_record do
    gem 'pg', '>= 1.0.0', platforms: :ruby
    gem 'paper_trail', '>= 12.0'

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 60.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 60.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 60.0'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 7.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'cancancan-mongoid'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-6.1' do
  gem 'rails', '~> 6.1.0'
  gem 'sassc-rails', '~> 2.1'
  gem 'devise', '~> 4.7'
  gem 'turbo-rails', platform: :jruby, github: 'hotwired/turbo-rails'

  group :test do
    gem 'cancancan', '~> 3.2'
    gem 'kt-paperclip'
    gem 'rspec-rails', '>= 4.0.0.beta2'
    gem 'shrine', '~> 3.0'
  end

  group :active_record do
    gem 'pg', '>= 1.0.0', platforms: :ruby
    gem 'paper_trail', '>= 12.0'

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 61.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 61.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 61.0'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 7.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'cancancan-mongoid'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-7.0' do
  gem 'rails', '~> 7.0.0'
  gem 'sassc-rails', '~> 2.1'
  gem 'devise', '~> 4.8'

  group :test do
    gem 'cancancan', '~> 3.2'
    gem 'kt-paperclip'
    gem 'rspec-rails', '>= 4.0.0.beta2'
    gem 'shrine', '~> 3.0'
  end

  group :active_record do
    gem 'pg', '>= 1.0.0', platforms: :ruby
    gem 'paper_trail', '>= 12.0'
  end
end

appraise 'composite_primary_keys' do
  gem 'rails', '~> 7.0.0'
  gem 'sassc-rails', '~> 2.1'
  gem 'devise', '~> 4.8'

  group :test do
    gem 'cancancan', '~> 3.2'
    gem 'kt-paperclip'
    gem 'rspec-rails', '>= 4.0.0.beta2'
    gem 'shrine', '~> 3.0'
  end

  group :active_record do
    gem 'composite_primary_keys'
    gem 'paper_trail', '>= 12.0'
  end
end
