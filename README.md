# RailsAdmin [![Build Status](https://secure.travis-ci.org/sferik/rails_admin.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/sferik/rails_admin.png?travis)][gemnasium] [![Click here to lend your support to: RailsAdmin and make a donation at www.pledgie.com !](https://www.pledgie.com/campaigns/15917.png?skin_name=chrome)][pledgie]
RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.

[travis]: http://travis-ci.org/sferik/rails_admin
[gemnasium]: https://gemnasium.com/sferik/rails_admin
[pledgie]: http://www.pledgie.com/campaigns/15917

It started as a port of [MerbAdmin][merb-admin] to Rails 3 and was implemented
as a [Ruby Summer of Code project][rubysoc] by [Bogdan Gaza][hurrycane] with
mentors [Erik Michaels-Ober][sferik], [Yehuda Katz][wycats], [Luke van der
Hoeven][plukevdh], and [Rein Henrichs][reinh].

[merb-admin]: https://github.com/sferik/merb-admin
[rubysoc]: http://www.rubysoc.org/projects
[hurrycane]: https://github.com/hurrycane
[sferik]: https://github.com/sferik
[wycats]: https://github.com/wycats
[plukevdh]: https://github.com/plukevdh
[reinh]: https://github.com/reinh

## <a name="features"></a>Features

* Display database tables
* Create new data
* Easily update data
* Safely delete data
* Custom actions
* Automatic form validation
* Search and filtering
* Export data to CSV/JSON/XML
* Authentication (via [Devise](https://github.com/plataformatec/devise))
* Authorization (via [Cancan](https://github.com/ryanb/cancan))
* User action history (internally or via [PaperTrail](https://github.com/airblade/paper_trail))
* Supported ORMs
  * ActiveRecord
  * Mongoid [new]

## <a name="demo"></a>Demo

Take RailsAdmin for a [test drive][demo] with sample data. ([Source code.][dummy_app])

[demo]: http://rails-admin-tb.herokuapp.com/
[dummy_app]: https://github.com/bbenezech/dummy_app

## <a name="installation"></a>Installation
In your `Gemfile`, add the following dependencies:

    gem 'fastercsv' # Only required on Ruby 1.8 and below
    gem 'rails_admin'

Run:

    $ bundle install

And then run:

    $ rails g rails_admin:install

This generator will install RailsAdmin and [Devise](https://github.com/plataformatec/devise) if you
don't already have it installed. [Devise](https://github.com/plataformatec/devise) is strongly
recommended to protect your data from anonymous users.
It will modify your `config/routes.rb`, adding:

```ruby
mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' # Feel free to change '/admin' to any namespace you need.
```

It will also add an intializer that will help you getting started. (head for config/initializers/rails_admin.rb)

Optionally, you may wish to set up [Cancan](https://github.com/ryanb/cancan),
[PaperTrail](https://github.com/airblade/paper_trail), [CKeditor](https://github.com/galetahub/ckeditor)

More on that in the [Wiki](https://github.com/sferik/rails_admin/wiki)

## <a name="usage"></a>Usage
Start the server:

    $ rails server

You should now be able to administer your site at
[http://localhost:3000/admin](http://localhost:3000/admin).

## <a name="configuration"></a>Configuration

All configuration documentation has moved to the wiki: https://github.com/sferik/rails_admin/wiki

## <a name="support"></a>Support
Please see [list of known issues](https://github.com/sferik/rails_admin/wiki/Troubleshoot) first.

If you have a question, please check this README, the wiki, and the list of known issues.

If you still have a question, you can ask the [official RailsAdmin mailing
list](http://groups.google.com/group/rails_admin) or ping sferik on IRC in
[#railsadmin on
irc.freenode.net](http://webchat.freenode.net/?channels=railsadmin).

If you think you found a bug in RailsAdmin, you can [submit an
issue](https://github.com/sferik/rails_admin#issues).
No feature requests or questions please (the mailing list is
active and is the preferred venue for feature requests and questions).

## <a name="contributing"></a>Contributing
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html),
**everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by [translating to a new language](https://github.com/sferik/rails_admin/wiki/Translations)
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/sferik/rails_admin/issues)
* by reviewing patches
* [financially](http://pledgie.com/campaigns/15917)

## <a name="issues"></a>Submitting an Issue
We use the [GitHub issue tracker](https://github.com/sferik/rails_admin/issues) to track bugs and
features. Before submitting a bug report or feature request, please check to make sure it hasn't already
been submitted. You can indicate support for an existing issue by voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

## <a name="pulls"></a>Submitting a Pull Request
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.  *NOTE* - there's a small test app located in the
spec/dummy_app directory that you can use to experiment with rails_admin.
4. Add documentation for your feature or bug fix.
5. Add specs for your feature or bug fix.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec, version, or history file.
(If you want to create your own version for some reason, please do so in a separate commit.)

## <a name="versions"></a>Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* [Rubinius][]
* [JRuby][]

[rubinius]: http://rubini.us/
[jruby]: http://jruby.org/

## <a name="screenshots"></a>Screenshots
![Dashboard view](https://github.com/sferik/rails_admin/raw/master/screenshots/dashboard.png "dashboard view")
![Delete view](https://github.com/sferik/rails_admin/raw/master/screenshots/delete.png "delete view")
![List view](https://github.com/sferik/rails_admin/raw/master/screenshots/list.png "list view")
![Nested view](https://github.com/sferik/rails_admin/raw/master/screenshots/nested.png "nested view")
![Polymophic edit view](https://github.com/sferik/rails_admin/raw/master/screenshots/polymorphic.png "polymorphic view")
