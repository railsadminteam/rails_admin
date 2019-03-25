# RailsAdmin

[![Gem Version](https://img.shields.io/gem/v/rails_admin.svg)][gem]
[![Build Status](https://img.shields.io/travis/sferik/rails_admin.svg)][travis]
[![Coverage Status](https://img.shields.io/coveralls/sferik/rails_admin.svg)][coveralls]
[![Inline docs](http://inch-ci.org/github/sferik/rails_admin.svg)][inch]
[![Code Climate](https://codeclimate.com/github/sferik/rails_admin.svg)][codeclimate]
[![SemVer](https://api.dependabot.com/badges/compatibility_score?dependency-name=rails_admin&package-manager=bundler&version-scheme=semver)][semver]

[gem]: https://rubygems.org/gems/rails_admin
[travis]: https://travis-ci.org/sferik/rails_admin
[coveralls]: https://coveralls.io/r/sferik/rails_admin
[inch]: http://inch-ci.org/github/sferik/rails_admin
[codeclimate]: https://codeclimate.com/github/sferik/rails_admin
[semver]: https://dependabot.com/compatibility-score.html?dependency-name=rails_admin&package-manager=bundler&version-scheme=semver

RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.

## Announcements

### [Action required] Security issue

> **RailsAdmin prior to 1.3.0 have been reported to have XSS vulnerability.** We strongly recommend that you upgrade RailsAdmin to 1.3.0 or later as soon as possible, if you are on those versions. See [#2985](https://github.com/sferik/rails_admin/issues/2985) for the detail.
> 
> Also, 1.0.0 and 1.1.0 is known to have [CSRF vulnerability](https://github.com/sferik/rails_admin/commit/b13e879eb93b661204e9fb5e55f7afa4f397537a), too.

## Getting started

* Check out [the docs][docs].
* Try the [live demo][demo]. ([Source code][dummy_app])

[demo]: http://rails-admin-tb.herokuapp.com/
[dummy_app]: https://github.com/bbenezech/dummy_app
[docs]: https://github.com/sferik/rails_admin/wiki

## Features
* CRUD any data with ease
* Custom actions
* Automatic form validation
* Search and filtering
* Export data to CSV/JSON/XML
* Authentication (via [Devise](https://github.com/plataformatec/devise) or other)
* Authorization (via [CanCanCan](https://github.com/CanCanCommunity/cancancan) or [Pundit](https://github.com/elabs/pundit))
* User action history (via [PaperTrail](https://github.com/airblade/paper_trail))
* Supported ORMs
  * ActiveRecord
  * Mongoid



## Installation

1. On your gemfile: `gem 'rails_admin', '~> 1.3'`
2. Run `bundle install`
3. Run `rails g rails_admin:install`
4. Provide a namespace for the routes when asked
5. Start a server `rails s` and administer your data at [/admin](http://localhost:3000/admin). (if you chose default namespace: /admin)

## Configuration
### Global
In `config/initializers/rails_admin.rb`:

[Details](https://github.com/sferik/rails_admin/wiki/Base-configuration)

To begin with, you may be interested in setting up [Devise](https://github.com/sferik/rails_admin/wiki/Devise), [CanCanCan](https://github.com/sferik/rails_admin/wiki/Cancancan) or [Papertrail](https://github.com/sferik/rails_admin/wiki/Papertrail)!

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

Details: [Models](https://github.com/sferik/rails_admin/wiki/Models), [Groups](https://github.com/sferik/rails_admin/wiki/Groups), [Fields](https://github.com/sferik/rails_admin/wiki/Fields)

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

* Ruby 2.1
* Ruby 2.2
* Ruby 2.3
* Ruby 2.4
* Ruby 2.5
* [Rubinius][]
* [JRuby][]

[rubinius]: http://rubinius.com
[jruby]: http://jruby.org/
