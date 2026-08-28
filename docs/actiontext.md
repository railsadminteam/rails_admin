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

The method you should take varies depending on how your application is configured to deliver RailsAdmin assets.

### Sprockets

RailsAdmin will automatically load required assets. No setup is needed.

### ImportMap

Install the ActionText NPM package.

```bash
$ yarn add @rails/actiontext
```

Add following contents to files within your Rails application.

`config/importmap.rails_admin.rb` (be sure to use the latest version for each package!)

```ruby
pin '@rails/actioncable/src', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.4/src/index.js'
pin '@rails/actiontext', to: 'https://ga.jspm.io/npm:@rails/actiontext@7.0.4-1/app/assets/javascripts/actiontext.js'
pin '@rails/activestorage', to: 'https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js'
pin 'trix', to: 'https://ga.jspm.io/npm:trix@2.0.0-beta.0/dist/trix.js'
```

`app/javascript/rails_admin.js`

```js
import "trix";
import "@rails/actiontext";
```

`app/assets/stylesheets/rails_admin.scss`

```css
@import "trix/dist/trix";
```

### Webpacker or Webpack

Install the ActionText NPM package.

```bash
$ yarn add @rails/actiontext
```

Add following contents to files within your Rails application.

`app/javascript/packs/rails_admin.js` or `app/javascript/rails_admin.js`

```js
import "trix";
import "@rails/actiontext";
```

`app/javascript/stylesheets/rails_admin.scss` or `app/assets/stylesheets/rails_admin.scss`

```css
@import "trix/dist/trix";
```

[More here](https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/action_text.rb)
