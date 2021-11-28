### Scoping, ordering and limiting associable records in filtering selects/multiselects

You may have business rules where you want to limit the members of a collection that are available for association with a particular record. For example, a Player might be a member of a League. When selecting Players for a Team, we wouldn't want to see all the Players we know about, just the ones in the same League as the Team.

For all associations types (other than polymorphics at the moment) you can scope associable records with:

```ruby
config.model Team do
  field :players do
    associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
    associated_collection_scope do
      # bindings[:object] & bindings[:controller] are available, but not in scope's block!
      team = bindings[:object]
      Proc.new { |scope|
        # scoping all Players currently, let's limit them to the team's league
        # Be sure to limit if there are a lot of Players and order them by position
        scope = scope.where(league_id: team.league_id) if team.present?
        scope = scope.limit(30) # 'order' does not work here
      }
    end
  end
end
```

Use `associated_collection_cache_all true` if you want all associated records preloaded.
Defaults to true if there are less than 100 records in the associated collection.
The scope will default to limit records to 30, unless cache_all is true (no limit).

**bindings[:object] can be null for new parent records!** Also note that the scope takes in to account the saved version of the record, not considering any unsaved changes you may have made in the edit form. If you change the team's league, you'll still see the players from the old league until you save.

Validating associations is up to your models, and you'll certainly want to set the up properly. This functionality is basically a filter--that allows you to scope in on the records you're likely to want. It does not enforce what gets mapped in your database. If the Team knows the id of a Player in another League, he can associate it. Use `authorization` or association conditions, and a validation, to prevent that.

### Scoping the relation itself with conditions

This is good and all but it doesn't ensure anything about security and sanity!

Now let's see the relation itself:

```ruby
    class Team
      has_many :number_time_players, :conditions => proc { { :position => Time.now.to_i } }, :class_name => 'Player'
    end
```

console:

```
 > Team.first.number_time_players.build
=> #<Player id: nil, <snip> position: 1320166460, <snip>>
 > Team.first.number_time_players.build
=> #<Player id: nil, <snip> position: 1320166461, <snip>>
 > Team.first.number_three_players
Player Load (1.2ms)  SELECT "players".* FROM "players" WHERE "players"."team_id" = 1 AND "players"."position" = 1320167057
```

Note that position changes at each request, you can use lambdas.
You can use `:after_add` hook to reject records you don't want (sanity check).
More on ActiveRecord's API pages.

RailsAdmin doesn't know about :conditions in your association, so you'll need to use `authorization` or `associated_collection_scope` to scope visible records (in the select box)

### Restricting records based on association scope

You can configure RailsAdmin to use the scope as defined on your association (also works on through associations). The following code will result in only showing `active` players for the Players field on the Team form:

```ruby
class Team < ApplicationRecord
  has_many :memberships, inverse_of: :team
  has_many :players, through: :memberships
end

class Membership < ApplicationRecord
  belongs_to :team, inverse_of: :memberships
  belongs_to :player, -> { active }, inverse_of: :memberships
end

class Player < ApplicationRecord
  has_many :memberships, inverse_of: :player
  scope :active, -> { where(retired: false) }
end

config.model Team do
  edit do
    include_fields :policy_section, :title, :description, :players
    configure :players do
      associated_collection_scope do
        resource_scope = bindings[:object].class.reflect_on_association(:players).source_reflection.scope

        proc do |scope|
          resource_scope ? scope.merge(resource_scope) : scope
        end
      end
    end
  end
end
```

### Restricting records through authorization

Another way to scope potential records is to use authorization, through Cancan:

```ruby
class Ability
  include CanCan::Ability
  def initialize(user)
    can :manage, Contact, :email => user.email
  end
end
```

The advantage here is that user will never be able to see 'wrong' contacts and he won't be able to set a wrong email.
More on cancan's own page.

### Restricting fields through roles or some condition

You can also restrict some field through role or some condition, [take a look at this post](https://glaucocustodio.github.io/2013/11/28/conditional-fields-in-rails-admin/)
