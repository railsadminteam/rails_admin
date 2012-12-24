source :rubygems

group :active_record do
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.2'
    gem 'jdbc-sqlite3', '~> 3.6'
  end

  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'mysql', '2.8.1'
    when 'postgresql'
      gem 'pg', '~> 0.13'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
end

group :mongoid do
  gem 'mongoid', '~> 3.0'
  gem 'mongoid-paperclip', '~> 0.0.8', :require => 'mongoid_paperclip'
  gem 'carrierwave-mongoid', '~> 0.3', :require => 'carrierwave/mongoid'
end

group :debug do
  platform :mri_19 do
    gem 'debugger', '~> 1.2'
    gem 'simplecov', '~> 0.6', :require => false
  end
end

group :development, :test do
  gem 'strong_parameters', '~> 0.1.5'
  gem 'cancan', '~> 1.6'
  gem 'capybara', '~> 1.1'
  gem 'carrierwave', '~> 0.6'
  gem 'database_cleaner', '~> 0.8'
  gem 'devise', '~> 2.1'
  gem 'dragonfly', '~> 0.9'
  gem 'factory_girl', '~> 4.1'
  gem 'generator_spec', '~> 0.8'
  gem 'launchy', '~> 2.1'
  gem 'mini_magick', '~> 3.4'
  gem 'paperclip', '~> 3.3'
  gem 'rspec-rails', '~> 2.11'
  gem 'timecop', '~> 0.5'
end

gemspec
