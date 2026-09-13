Rails ships with a rich text editor, called ActionText. RailsAdmin can make use of it in two ways.

## Setting up the Rails part

Follow [the official documentation](https://edgeguides.rubyonrails.org/action_text_overview.html#installation) to configure ActionText.

```bash
$ rails action_text:install
```

```ruby
class Message < ApplicationRecord
  has_rich_text :content
end
```

At this point RailsAdmin will use the CDN-delivered ActionText assets and it lacks some features like uploading attachments. You'll see a warning like `ActionText assets should be loaded statically...` in your browser console as well. To eliminate the warning and get the full features, please proceed to the next section.

Alternatively, if you don't need the full features you can choose to suppress the warning by:

```ruby
field :action_text_field do
  warn_dynamic_load false
end
```

## Setting up the frontend

### `:propshaft` / `:sprockets` (default)

The bundle already includes the `@rails/actiontext` and `@rails/activestorage`
glue, so attachment uploads work out of the box. Trix itself is loaded from a CDN
when a `<trix-editor>` appears - to serve it statically, use `:external` below.

### `:external`

Add Trix (and its stylesheet) to the bundle you build:

`app/javascript/rails_admin.js`

```js
import "rails_admin/src/rails_admin/base";
import "trix";
```

`app/javascript/rails_admin.scss`

```scss
@import "trix/dist/trix";
@import "rails_admin/src/rails_admin/styles/base";
```

[More here](https://github.com/railsadminteam/rails_admin/blob/master/lib/rails_admin/config/fields/types/action_text.rb)
