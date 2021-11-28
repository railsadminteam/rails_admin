# CanCan remove associated action buttons in forms

**Help: I dont feel too confident about my ruby-skills. Please help improving this article by improving the source where needed, thanks**

In order to remove the "Add new"/"Edit" buttons for associated Models in the form without removing the ability to manage those associated models, cancan helps out well.

**Example: a User can :manage Authors and Books, but must not be able to :manage authors while in Books-Edit form**

The idea is pretty simple:

```ruby
   cannot [:create,:update], Model unless current_model == Model
```

The default CanCan AuthorizationAdapter however does not inform the Ability-Class about the current view/model, that is why it needs to be overwritten.

---

### In your Rails-App root:

<pre><code>mkdir -p lib/rails_admin/extensions/cancan/
cd  lib/rails_admin/extensions/cancan/;
wget https://raw.github.com/gist/3302673/7d013f23bba67a7c7317003c56117b2a88503d39/authorization_adapter.rb
</code></pre>

This file, contains the ControllerExtension-Module, cloned from RailsAdmins original CanCan AuthorizationAdapter, except for the 2nd Parameter in @ability.new, which represents the current displayed model you want to edit.

This gist contains:

```ruby
module RailsAdmin
  module Extensions
    module CanCan
      class AuthorizationAdapter
        private
        module ControllerExtension
          def current_ability
            @current_ability ||= @ability.new(_current_user, self.params["model_name"])
          end
        end
      end
    end
  end
end
```

---

### config/initializers/rails_admin.rb

the CanCan configuration will remain the same, except for loading the updated authorization_adapter.rb.

```ruby
   require Rails.root.join('lib/rails_admin/extensions/cancan/authorization_adapter')
   RailsAdmin.config do |config|
   ....
```

I load the authorization_adapter here, since i find it belongs to rails_admins configuration, which i dont want to have "all over the app".

---

### Ability-Class

The only mandatory update is to add a further parameter to the initialize method, named like request_model. It is the Model-Class you are viewing,editing in RailsAdmin.

My Example from above was: "a User can :manage Authors and Books, but should not be able to manage Autors while in Books-Edit form"

this can result in something like:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user, request_model)

    if user
      can :access, :rails_admin
      can :dashboard
      can :manage, :all

      # For all Models we have, forbid create and update
      # but dont forbid :manage, in order to keep it in
      # navigation if not excluded by rails_admin config
      ActiveRecord::Base.descendants.each do |m|
        cannot [:create, :update], m unless request_model == m.name.underscore
      end if request_model

      # a manual way can look like this :
      # cannot [:create, :update], Author if request_model == "books"
      # cannot [:create, :update], Book   if request_model == "author"

    else
      cannot :access, :rails_admin
    end
  end
end

```

Thats it, now the Edit/Create associated Model-buttons are gone, but the Model remains in the Navigation.
This is quite usefull if a User may create associations with models which are excluded via rails_admin config
