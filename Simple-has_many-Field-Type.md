[RailsAdminSimpleHasMany](https://github.com/aiman86/rails_admin_simple_has_many) is a field type for Rails Admin for has_many associations that do not require a complex multiselect field (e.g. only a single select list with inline add and destroy). RailsAdminSimpleHasMany has been only tested with Mongoid adapter and on Chrome/Safari. I do not expect major issues with other ORMs or browsers, but bugs and enhancements pull requests are welcome!

Example of how the collection field would look like:

![RailsAdmin Simple has_many](https://s3.amazonaws.com/aimannajjar.com/assets/images/portfolio/rails_admin_simple_has_many_sm.png)

## Usage
Simply add the following gem to your Gemfile:
```code
gem "rails_admin_simple_has_many"
```
And then run `bundle` (note: `rails_admin` should already be in your Gemfile)

Next, add the field as follows in your model

```ruby
rails_admin do
    field :players, :simple_has_many do
        help 'Please add 12 players'
        required true
    end
end
```
