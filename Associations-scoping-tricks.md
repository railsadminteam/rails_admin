### Restricting associable records

For all associations type, (except polymorphic ones at the moment) you can visually scope associable records with: 

```ruby
associated_collection_scope do
  # bindings[:object] & bindings[:controller] are available, but not in scope's block!
  user = bindings[:object]
  Proc.new { |scope|
    user ? scope.where(user_id => user.id) : scope
  }
end
```

**bindings[:object] can be null for new parent records!**

Of course if the user knows the id of some other record, he can associate them as well! You'll need `authorization` or association conditions to prevent that.

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
More on ActiveRecord's API page.

RailsAdmin doesn't know about :conditions in your association, so you'll need to use `authorization` or `associated_collection_scope` to scope visible records (in the select box)

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