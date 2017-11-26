appraise "rails-4.0" do
  gem 'rails', '~> 4.0.0'
  gem 'sass-rails', '~> 4.0.3'
  gem 'devise', '>= 3.2'
  gem 'test-unit'
  gem 'capybara', '>= 0.8', group: :test
  gem 'kaminari', '~> 0.14'

  group :active_record do
    gem 'paper_trail', '~> 5.0'

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 1.2'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0.beta1'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 5.0'
    gem 'kaminari-mongoid', '~> 0.1'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', github: 'DimaSamodurov/refile-mongoid', platforms: [:ruby_21, :ruby_22, :ruby_23]
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

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 1.2'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0.beta1'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 5.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', github: 'DimaSamodurov/refile-mongoid', platforms: [:ruby_21, :ruby_22, :ruby_23]
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

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 1.2'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0.beta1'
    end
  end

  group :mongoid do
    gem 'mongoid', '~> 5.0'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
    gem 'refile-mongoid', github: 'DimaSamodurov/refile-mongoid', platforms: [:ruby_21, :ruby_22, :ruby_23]
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

    platforms :jruby do
      gem 'activerecord-jdbcmysql-adapter', '~> 50.0'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 50.0'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 50.0'
    end
  end

  group :mongoid do
    gem 'mongoid', '>= 6.0.0.beta'
    gem 'kaminari-mongoid'
    gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
    gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
  end
end

appraise "rails-5.1" do
  gem 'rails', '~> 5.1.0'
  gem 'sass-rails', '~> 5.0'
  gem 'devise', github: 'plataformatec/devise'

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
