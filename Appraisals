# frozen_string_literal: true

appraise 'rails-7.1' do
  gem 'rails', '~> 7.1.0'
  gem 'importmap-rails', require: false

  group :active_record do
    platforms :ruby, :mswin, :mingw, :x64_mingw do
      gem 'sqlite3', '~> 1.3'
    end

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 71.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 71.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 71.0'
    end
  end

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 8.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-7.2' do
  gem 'rails', '~> 7.2.0'
  gem 'importmap-rails', require: false

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 8.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-8.0' do
  gem 'rails', '~> 8.0.0'
  gem 'importmap-rails', require: false

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 9.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-8.1' do
  gem 'rails', '~> 8.1.0'
  gem 'importmap-rails', require: false

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 9.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'composite_primary_keys' do
  gem 'rails', '~> 7.0.0', '7.0.8.6' # Pinning until the fix for https://github.com/basecamp/trix/issues/1209 become available in actiontext
  gem 'concurrent-ruby', '1.3.4' # Workaround for https://github.com/rails/rails/issues/54260

  group :active_record do
    gem 'composite_primary_keys'

    platforms :ruby, :mswin, :mingw, :x64_mingw do
      gem 'sqlite3', '~> 1.3'
    end
  end
end
