# frozen_string_literal: true

appraise 'rails-6.0' do
  gem 'rails', '~> 6.0.0'
  gem 'psych', '~> 3.3'
  gem 'turbo-rails', '< 2.0.8'

  group :test do
    gem 'cancancan', ['~> 3.0', '< 3.6']
    gem 'pundit', '~> 2.1.0'
  end

  group :active_record do
    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 60.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 60.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 60.0'
    end
  end

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 7.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-6.1' do
  gem 'rails', '~> 6.1.0'

  group :active_record do
    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 61.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 61.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 61.0'
    end
  end

  group :mongoid do
    gem 'cancancan-mongoid'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'database_cleaner-mongoid', '>= 2.0', require: false
    gem 'kaminari-mongoid'
    gem 'mongoid', '~> 7.0'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'shrine-mongoid', '~> 1.0'
  end
end

appraise 'rails-7.0' do
  gem 'rails', '~> 7.0.0'
  gem 'importmap-rails', require: false

  group :active_record do
    platforms :ruby, :mswin, :mingw, :x64_mingw do
      gem 'sqlite3', '~> 1.3'
    end

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 70.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 70.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 70.0'
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

appraise 'rails-7.1' do
  gem 'rails', '~> 7.1.0'
  gem 'importmap-rails', require: false

  group :active_record do
    platforms :ruby, :mswin, :mingw, :x64_mingw do
      gem 'sqlite3', '~> 1.3'
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
end

appraise 'rails-8.0' do
  gem 'rails', '~> 8.0.0'
  gem 'importmap-rails', require: false
end

appraise 'composite_primary_keys' do
  gem 'rails', '~> 7.0.0'

  group :active_record do
    gem 'composite_primary_keys'

    platforms :ruby, :mswin, :mingw, :x64_mingw do
      gem 'sqlite3', '~> 1.3'
    end
  end
end
