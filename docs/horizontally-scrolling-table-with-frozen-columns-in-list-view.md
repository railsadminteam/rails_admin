Here's a technique that you can use to make the list view table show all of the columns on a single page, with horizontal scrolling and frozen header columns in the table.

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
$(document).on('rails_admin.dom_ready', function(){
  var $table = $('#bulk_form').find('table');
  var table = $table[0];

  // Abort if there's nothing to do. Don't repeat ourselves, either.
  if (!table || $table.hasClass('js-horiz-scroll')) { return; }

  // Add our indicator class. Also some enhancements.
  $table.addClass('js-horiz-scroll table-hover');

  ////
  // Make the table horizontally scrollable.
  // Inspiration from bootstrap's table-responsive.
  ////
  var tableWrapper = document.createElement('DIV');
  //tableWrapper.className = 'table-responsive';
  //tableWrapper.style.width = '100%';
  tableWrapper.style.overflowX = 'auto';
  tableWrapper.style.marginBottom = table.style.marginBottom;
  table.style.marginBottom = '0';
  //tableWrapper.style.overflowY = 'hidden';
  table.parentElement.insertBefore(tableWrapper, table);
  tableWrapper.appendChild(table);
  $table.find('th.last,td.last').each(function(index, td){
    var tr = td.parentElement;
    tr.insertBefore(td, tr.children[1]);
  });

  ////
  // Freeze the left columns.
  // Inspiration from http://stackoverflow.com/questions/1312236/how-do-i-create-an-html-table-with-fixed-frozen-left-column-and-scrollable-body
  ////
  var $trs = $table.find('tr');
  var $headerTr = $trs.first();
  var $headerTds = $headerTr.children('th,td');
  var i, $td, pos;
  var margin = 0;
  var offsets = [];
  for (i = 0; i < 3; i++) {
    $td = $($headerTds[i]);
    pos = $td.position();
    offsets.push(pos.left);
    margin = pos.left + $td.outerWidth();
  }
  $trs.each(function(index, tr){
    for (i = 0; i < 3; i++) {
      tr.children[i].style.position = 'absolute';
      tr.children[i].style.left = offsets[i]+'px';
    }
  });
  tableWrapper.style.marginLeft = margin+'px';
  tableWrapper.style.borderLeft = '1px solid black';

  // Bottom-align the headers.
  var trHeight = $headerTr.height();
  for (i = 0; i < 3; i++) {
    $td = $($headerTr[0].children[i]);
    $td.css('padding-top', (trHeight - $td.height() - 4)+'px');
  }

  // Remove main browser window's horizontal scrollbar.
  $('body').css('overflow-x', 'hidden');
});
```

Now be sure to do whatever else might be required in order to get the custom javascript included in your compiled assets, such as bumping your `Rails.application.config.assets.version` - https://github.com/sferik/rails_admin/issues/738#issuecomment-68483204 - or other things mentioned in that issue.

Some parts of the above could be achieved by customizing `app/views/rails_admin/main/index.html.haml` and/or adding custom CSS instead of javascript, but that approach would require overriding a rather substantial file, which doesn't lend itself to easily upgrading your gems.

Enjoy!