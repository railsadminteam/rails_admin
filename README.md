# RailsAdmin

[![Gem Version](https://img.shields.io/gem/v/rails_admin.svg)][gem]
[![Build Status](https://img.shields.io/travis/sferik/rails_admin.svg)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/sferik/rails_admin.svg)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/sferik/rails_admin.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/sferik/rails_admin.svg)][coveralls]
[![Inline docs](http://inch-ci.org/github/sferik/rails_admin.svg)][inch]

[gem]: https://rubygems.org/gems/rails_admin
[travis]: http://travis-ci.org/sferik/rails_admin
[gemnasium]: https://gemnasium.com/sferik/rails_admin
[codeclimate]: https://codeclimate.com/github/sferik/rails_admin
[coveralls]: https://coveralls.io/r/sferik/rails_admin
[inch]: http://inch-ci.org/github/sferik/rails_admin

RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.

## Features
* CRUD any data with ease
* Custom actions
* Automatic form validation
* Search and filtering
* Export data to CSV/JSON/XML
* Authentication (via [Devise](https://github.com/plataformatec/devise) or other)
* Authorization (via [Cancan](https://github.com/ryanb/cancan))
* User action history (via [PaperTrail](https://github.com/airblade/paper_trail))
* Supported ORMs
  * ActiveRecord
  * Mongoid



## Installation

1. Bundle the gem
2. Run `rails g rails_admin:install`
3. Provide a namespace for the routes when asked
4. Start a server `rails s` and administer your data at [/admin](http://localhost:3000/admin). (if you chose default namespace: /admin)

## Configuration
### Global
In `config/initializers/rails_admin`:

[Details](https://github.com/sferik/rails_admin/wiki/Base-configuration)

To begin with, you may be interested in setting up [Devise](https://github.com/sferik/rails_admin/wiki/Devise), [Cancan](https://github.com/sferik/rails_admin/wiki/Cancan) or [Papertrail](https://github.com/sferik/rails_admin/wiki/Papertrail)!

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

[Details](https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL)

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
* Ruby 2.1.1
* [Rubinius][]
* [JRuby][]

[rubinius]: http://rubini.us/
[jruby]: http://jruby.org/
