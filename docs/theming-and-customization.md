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

There are 2 ways of customizing RailsAdmin frontend by injecting user-defined JavaScript codes and stylesheets, depending on the asset delivery method.

## Sprockets

For customization, simply override these files in your app:

```
app/assets/stylesheets/rails_admin/custom/mixins.scss
app/assets/stylesheets/rails_admin/custom/theming.scss
app/assets/stylesheets/rails_admin/custom/variables.scss
app/assets/javascripts/rails_admin/custom/ui.js
```

SCSS files are meant to be used for following purposes:

* modify all the mixins provided by rails_admin and bootstrap and add others for you to use in `mixins.scss`. (available mixins [here](https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_mixins.scss))
* modify all the variables provided by rails_admin and bootstrap and add others for you to use in `variables.scss`. Note that the variables in `variables.scss` are imported before Bootstrap's variables which all have set the [!default](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#variable_defaults_) flag. This effectively means that you can customize chained variables by just assigning a custom value to the first one instead of the need to  override each single one. E.g. you do not have to override `$btn-success-bg`, `$label-succes-bg` and `$progress-bar-success-bg` but only assign a custom value to `$brand-success`. (available variables [here](https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_variables.scss))
* In `theming.scss`, you can use all mixins and variables. (your owns, Bootstrap's and RailsAdmin's)

Don't forget to re-compile your assets or simply delete the content of your `tmp/cache` folder. Some additional steps might be required, as others reported here: https://github.com/sferik/rails_admin/issues/738#issuecomment-26615578


## Non-Sprockets setup

Upon the RailsAdmin installation, the installer will generate files `rails_admin.js` and `rails_admin.scss` (location will vary depending on [the asset delivery method](base-configuration.md#asset-delivery)). You can freely add your custom code or import a new dependency there.

## Working with JavaScript code

RailsAdmin 3.x uses Turbo Drive (https://turbo.hotwired.dev/) to load pages instead of normal HTTP requests. That means your HTML-interacting code can't simply use jQuery's `$(document).ready` or wait for `DOMContentLoaded`. Instead, you can hook to the custom JavaScript event which RailsAdmin triggers when the page content is ready.

```javascript
$(document).on('rails_admin.dom_ready', function() { 
  /* your js code here */
});
``` 
When using Rails Admin 3.1.2+ and Rails 7.x+, you can simply omit JQuery and listen to document directly.

```javascript
// Events are emitted the following way by rails_admin
new CustomEvent("rails_admin.dom_ready", { detail: form });

// When trying to catch and read these events you can simply listen for it via the document.'

document.addEventListener('rails_admin.dom_ready', (e) => {
  console.log(e)
  // This returns the target form in this example
   /* your js code here */
})

```