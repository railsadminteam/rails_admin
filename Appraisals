# frozen_string_literal: true

appraise 'rails-6.0' do
  gem 'rails', '~> 6.0.0'

  group :test do
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
    gem 'mongoid', '~> 7.0'
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
    gem 'mongoid', '~> 7.0'
  end
end

appraise 'rails-7.0' do
  gem 'rails', '~> 7.0.0'
  gem 'importmap-rails', require: false

  group :active_record do
    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 70.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 70.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 70.0'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 8.0'
  end
end

appraise 'rails-7.1' do
  gem 'rails', '~> 7.1.0'
  gem 'importmap-rails', require: false

  group :mongoid do
    gem 'mongoid', '~> 8.0'
  end
end

appraise 'composite_primary_keys' do
  gem 'rails', '~> 7.0.0'

  group :active_record do
    gem 'composite_primary_keys'
  end
end
