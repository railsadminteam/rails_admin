The content of this page applies to RailsAdmin 3.x.
Pre-3.x users should refer to [Theming and customization for RailsAdmin 2.x and earlier](theming-and-customization-for-railsadmin-2-x-and-earlier.md).

# Theming

Since RailsAdmin is built on top of the Web frontend framework [Bootstrap](https://getbootstrap.com/), it can be integrated easily with Bootstrap themes out there. There's one limitation though, your application needs to use [an asset delivery method](base-configuration.md#asset-delivery) other than Sprockets since this setup relies on the NPM ecosystem.

Let's take [Bootswatch](https://bootswatch.com/) as an example here. First you install the NPM package:

```bash
$ yarn add bootswatch
```

Then you add following content into your RailsAdmin stylesheet, located in either `app/javascript/stylesheets/rails_admin.scss` or `app/assets/stylesheets/rails_admin.scss`.

```diff
+ @import "bootswatch/dist/journal/variables";
  @import "rails_admin/src/rails_admin/styles/base.scss";
+ @import "bootswatch/dist/journal/bootswatch";
```

This way you'll get the [Bootswatch Journal](https://bootswatch.com/journal/)-themed RailsAdmin.

<img src="https://user-images.githubusercontent.com/486678/148493782-4b730372-4dd8-4533-b120-b05669610820.png" width="50%" />

# Customization

There are 2 ways of adding user-defined JavaScript and stylesheets to RailsAdmin.

## Injecting tags into `<head>` (any asset delivery method)

RailsAdmin renders an empty `_head_custom` partial at the end of its `<head>`.
Override it in your app to add your own `<script>` / `<style>` / `<link>` tags,
no build step required:

```erb
<%# app/views/layouts/rails_admin/_head_custom.html.erb %>
<%= stylesheet_link_tag "my_rails_admin_overrides", nonce: true %>
<%= javascript_include_tag "my_rails_admin_tweaks", nonce: true %>
<style nonce="<%= content_security_policy_nonce %>">
  .navbar-brand { font-weight: 700; }
</style>
```

This replaces the old `app/assets/{stylesheets,javascripts}/rails_admin/custom/*`
override files, which only worked under Sprockets.

## Adding to the bundle (`:external` setup)

When you build the assets yourself (`config.asset_source = :external`), the
installer generates `rails_admin.js` and `rails_admin.scss` (location varies
depending on [the asset delivery method](base-configuration.md#asset-delivery)).
You can freely add your custom code or import a new dependency there, including
Bootstrap variable overrides around the `@import "rails_admin/src/rails_admin/styles/base.scss"`
line as shown above.

## Working with JavaScript code

RailsAdmin 3.x uses Turbo Drive (https://turbo.hotwired.dev/) to load pages instead of normal HTTP requests. That means your HTML-interacting code can't simply use jQuery's `$(document).ready` or wait for `DOMContentLoaded`. Instead, you can hook to the custom JavaScript event which RailsAdmin triggers when the page content is ready.

```javascript
$(document).on("rails_admin.dom_ready", function () {
  /* your js code here */
});
```

When using Rails Admin 3.1.2+ and Rails 7.x+, you can simply omit JQuery and listen to document directly.

```javascript
// Events are emitted the following way by rails_admin
new CustomEvent("rails_admin.dom_ready", { detail: form });

// When trying to catch and read these events you can simply listen for it via the document.'

document.addEventListener("rails_admin.dom_ready", (e) => {
  console.log(e);
  // This returns the target form in this example
  /* your js code here */
});
```
