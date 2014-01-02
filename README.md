# RailsAdmin
[![Gem Version](https://badge.fury.io/rb/rails_admin.png)][gem]
[![Build Status](https://secure.travis-ci.org/sferik/rails_admin.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/sferik/rails_admin.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/sferik/rails_admin.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/sferik/rails_admin/badge.png?branch=master)][coveralls]
[![Gittip](http://img.shields.io/gittip/sferik.png)][gittip]

[gem]: https://rubygems.org/gems/rails_admin
[travis]: http://travis-ci.org/sferik/rails_admin
[gemnasium]: https://gemnasium.com/sferik/rails_admin
[codeclimate]: https://codeclimate.com/github/sferik/rails_admin
[coveralls]: https://coveralls.io/r/sferik/rails_admin
[gittip]: https://www.gittip.com/sferik/

RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.

## Features
* CRUD any data with ease
* Custom actions
* Automatic form validation
* Search and filtering
* Export data to CSV/JSON/XML
* Authentication (via [Devise](https://github.com/plataformatec/devise) or other)
* Authorization (via [Cancan](https://github.com/ryanb/cancan))
* User action history (internally or via [PaperTrail](https://github.com/airblade/paper_trail))
* Supported ORMs
  * ActiveRecord
  * Mongoid

## Installation
After you bundled the gem, mount RailsAdmin gem in `config/routes.rb`:

```ruby
mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' # Change '/admin' to any namespace you like.
```

Start a server `rails s` and administer your data at [/admin](http://localhost:3000/admin).

## Configuration
### Global
In `config/initializers/rails_admin`:

```ruby
RailsAdmin.config do |config|
  config.main_app_name = ["Cool app", "BackOffice"]
  # ...
end
```

Documentation in the [Wiki](https://github.com/sferik/rails_admin/wiki/Base-configuration)

### Per model
```ruby
class Ball < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :player

  rails_admin do
    configure :player do
      label 'Owner of this ball: '
    end
  end
end
```

Full documentation in the [Wiki](https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL)

## Documentation
https://github.com/sferik/rails_admin/wiki

## Demo
Take RailsAdmin for a [test drive][demo] with sample data. ([Source code.][dummy_app])

[demo]: http://rails-admin-tb.herokuapp.com/
[dummy_app]: https://github.com/bbenezech/dummy_app

## Support
If you have a question, please check this README, the wiki, and the [list of
known issues][troubleshoot].

[troubleshoot]: https://github.com/sferik/rails_admin/wiki/Troubleshoot

If you still have a question, you can ask the [official RailsAdmin mailing
list][list].

[list]: http://groups.google.com/group/rails_admin

If you think you found a bug in RailsAdmin, you can [submit an issue](https://github.com/sferik/rails_admin/issues/new).

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby implementations:

* Ruby 1.9.3
* Ruby 2.0.0
* [Rubinius][]
* [JRuby][]

[rubinius]: http://rubini.us/
[jruby]: http://jruby.org/
