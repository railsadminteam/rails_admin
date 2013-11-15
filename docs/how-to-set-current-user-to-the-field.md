Suppose you want to track who created a project so you want to set current_user to the field. You could do this in ```app/models/project.rb```:

rails_admin do 
  edit do 
    configure :user do
      visible false
    end
  
    field :user_id, :hidden do
      visible true
      default_value do
        bindings[:view]._current_user.id
      end
    end
  end 
end

This only hides the field and sets the default value, but it not secure. This default value can be overriden in POST request. So instead use your ability file to do this:
```
can :create, Project, user_id: user.id if user
```

You can allow to change this user in edit action.
```
rails_admin do
    edit do
      field :name
      field :description
      field :user do
        visible do
          ! bindings[:object].new_record?
        end
      end
    end
  end
end
```
