# Horizontally scrolling table with frozen columns in list view

Here's a technique that you can use to make the list view table show all of the columns on a single page, with horizontal scrolling and frozen header columns in the table. [PR #3017](https://github.com/railsadminteam/rails_admin/pull/3017) adds this feature with the config setting `sidescroll`, which is used as follows:

```ruby
RailsAdmin.config do |config|
  ...
  # Use default horizontal scroll settings of 3 frozen columns (checkboxes, links/actions, ID) with a border on the right:
  config.sidescroll = true

  # Use horizontal scrolling, but without any frozen columns:
  config.sidescroll = {num_frozen_columns: 0}

  # Freeze more or fewer columns (col 1 = checkboxes, 2 = links/actions):
  config.sidescroll = {num_frozen_columns: 4}
  config.sidescroll = {num_frozen_columns: 1}

  # Turn off horizontal scrolling for a specific model:
  config.model 'Team' do
    list do
      sidescroll false # "nil" doesn't work, it must be explicitly false
    end
  end

  # Use custom settings of horizontal scrolling for a specific model:
  config.model 'Team' do
    list do
      checkboxes false
      sidescroll(num_frozen_columns: 3) # per-model config does not account for checkboxes
    end
  end

  # Use horizontal scrolling only for a specific model:
  config.sidescroll = nil
  config.model 'Team' do
    list do
      sidescroll true
    end
  end
  ...
end
```

This feature uses the CSS `position: sticky` value. It is designed to degrade gracefully on browsers that do not support `sticky`: users of those browsers will still have a horizontally-scrolling table, but the first few columns will not be frozen.

Here are examples of what you'll get, using RailsAdmin's `spec/dummy_app` for an example.

Default - `config.sidescroll` unset:
![](https://user-images.githubusercontent.com/1115369/39540385-5804f2b8-4df7-11e8-93c4-3c1b77b647be.png)

`config.sidescroll = true` (some scrolling shown):
![](https://user-images.githubusercontent.com/1115369/39540539-c3e8fa06-4df7-11e8-958c-730ce13c22f7.png)

`config.sidescroll = {num_frozen_columns: 0}` (some scrolling shown):
![](https://user-images.githubusercontent.com/1115369/39540666-28615bc2-4df8-11e8-97fb-1f0bc2c246b6.png)

The following instructions allow you to add this feature to rails_admin before the PR is accepted/released.

First, make all of your columns show up on a single page by editing `config/initializers/rails_admin.rb`:

```ruby
RailsAdmin.config do |config|
  ...
  config.total_columns_width = 9999999
  ...
end
```

Next, add some custom javascript by creating `app/assets/javascripts/rails_admin/custom/ui.js`:

```javascript
(function () {
  var horizontalScrollList = function () {
    var $table = $("#bulk_form").find("table");
    var table = $table[0];

    // Abort if there's nothing to do. Don't repeat ourselves, either.
    if (!table || $table.hasClass("js-horiz-scroll")) {
      return;
    }

    // Add our indicator class. Also some enhancements.
    $table.addClass("js-horiz-scroll table-hover");

    ////
    // Make the table horizontally scrollable.
    // Inspiration from bootstrap's table-responsive.
    ////
    var tableWrapper = document.createElement("DIV");
    tableWrapper.style.overflowX = "auto";
    tableWrapper.style.marginBottom = "20px";
    table.style.marginBottom = "0";
    table.parentElement.insertBefore(tableWrapper, table);
    tableWrapper.appendChild(table);

    // Move the links column to the left.
    $table.find("th.last,td.last").each(function (index, td) {
      var tr = td.parentElement;
      tr.insertBefore(td, tr.children[1]);
    });

    // Allow a render before calculating positions.
    setTimeout(function () {
      // Freeze the left columns.
      var numFrozen = 3;
      var $trs = $("#bulk_form").find("table tr");
      var $headerTds = $trs.first().children("th,td");
      var i, bgColor;
      var offsets = [];
      for (i = 0; i < numFrozen; i++) {
        offsets.push($($headerTds[i]).position().left);
      }
      $trs.each(function (index, tr) {
        for (i = 0; i < numFrozen; i++) {
          tr.children[i].style.position = "sticky";
          tr.children[i].style.left = offsets[i] - offsets[0] + "px";
          if (i === numFrozen - 1) {
            tr.children[i].style.boxShadow = "-1px 0 0 0 #ddd inset";
            tr.children[i].style.paddingRight = "6px";
          }
          if (index % 2 === 0) {
            bgColor = "#fff";
            if (
              index === 0 &&
              tr.children[i].className.indexOf("headerSort") > -1
            ) {
              bgColor = "#e2eff6";
            }
            tr.children[i].style.backgroundColor = bgColor;
          }
        }
      });
    }, 0);
  };

  $(window).on("load", function () {
    // on 'load' to allow link icons to load.
    horizontalScrollList();
    $(document).on("rails_admin.dom_ready", horizontalScrollList);
  });
})();
```

Eslinted version (minus some no-parm reassign errors)

https://eslint.org/

```javascript
/* eslint-env jquery */

const horizontalScrollList = () => {
  const $table = $("#bulk_form").find("table");
  const table = $table[0];

  // Abort if there's nothing to do. Don't repeat ourselves, either.
  if (!table || $table.hasClass("js-horiz-scroll")) {
    return;
  }

  // Add our indicator class. Also some enhancements.
  $table.addClass("js-horiz-scroll table-hover");

  // Make the table horizontally scrollable.
  // Inspiration from bootstrap's table-responsive.
  const tableWrapper = document.createElement("DIV");
  tableWrapper.style.overflowX = "auto";
  tableWrapper.style.marginBottom = "20px";
  table.style.marginBottom = "0";
  table.parentElement.insertBefore(tableWrapper, table);
  tableWrapper.appendChild(table);

  // Move the links column to the left.
  $table.find("th.last,td.last").each((index, td) => {
    const tr = td.parentElement;
    tr.insertBefore(td, tr.children[1]);
  });

  // Allow a render before calculating positions.
  setTimeout(() => {
    // Freeze the left columns.
    const numFrozen = 3;
    const $trs = $("#bulk_form").find("table tr");
    const $headerTds = $trs.first().children("th,td");
    let i;
    let bgColor;
    const offsets = [];
    for (i = 0; i < numFrozen; i += 1) {
      offsets.push($($headerTds[i]).position().left);
    }
    $trs.each((index, tr) => {
      for (i = 0; i < numFrozen; i += 1) {
        tr.children[i].style.position = "sticky";
        tr.children[i].style.left = `${offsets[i] - offsets[0]}px`;
        if (i === numFrozen - 1) {
          tr.children[i].style.boxShadow = "-1px 0 0 0 #ddd inset";
          tr.children[i].style.paddingRight = "6px";
        }
        if (index % 2 === 0) {
          bgColor = "#fff";
          if (
            index === 0 &&
            tr.children[i].className.indexOf("headerSort") > -1
          ) {
            bgColor = "#e2eff6";
          }
          tr.children[i].style.backgroundColor = bgColor;
        }
      }
    });
  }, 0);
};

$(window).on("load", () => {
  // on 'load' to allow link icons to load.
  horizontalScrollList();
  $(document).on("rails_admin.dom_ready", horizontalScrollList);
});
```

Now be sure to do whatever else might be required in order to get the custom javascript included in your compiled assets, such as bumping your `Rails.application.config.assets.version` - https://github.com/railsadminteam/rails_admin/issues/738#issuecomment-68483204 - or other things mentioned in that issue.
