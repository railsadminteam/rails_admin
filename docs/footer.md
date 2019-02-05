Eslinted version (minus some no-parm reassign errors)
- https://eslint.org/

```
/* eslint-env jquery */

const horizontalScrollList = () => {
  const $table = $('#bulk_form').find('table');
  const table = $table[0];

  // Abort if there's nothing to do. Don't repeat ourselves, either.
  if (!table || $table.hasClass('js-horiz-scroll')) { return; }

  // Add our indicator class. Also some enhancements.
  $table.addClass('js-horiz-scroll table-hover');

  // Make the table horizontally scrollable.
  // Inspiration from bootstrap's table-responsive.
  const tableWrapper = document.createElement('DIV');
  tableWrapper.style.overflowX = 'auto';
  tableWrapper.style.marginBottom = '20px';
  table.style.marginBottom = '0';
  table.parentElement.insertBefore(tableWrapper, table);
  tableWrapper.appendChild(table);

  // Move the links column to the left.
  $table.find('th.last,td.last').each((index, td) => {
    const tr = td.parentElement;
    tr.insertBefore(td, tr.children[1]);
  });

  // Allow a render before calculating positions.
  setTimeout(() => {
    // Freeze the left columns.
    const numFrozen = 3;
    const $trs = $('#bulk_form').find('table tr');
    const $headerTds = $trs.first().children('th,td');
    let i;
    let bgColor;
    const offsets = [];
    for (i = 0; i < numFrozen; i += 1) {
      offsets.push($($headerTds[i]).position().left);
    }
    $trs.each((index, tr) => {
      for (i = 0; i < numFrozen; i += 1) {
        tr.children[i].style.position = 'sticky';
        tr.children[i].style.left = `${(offsets[i] - offsets[0])}px`;
        if (i === numFrozen - 1) {
          tr.children[i].style.boxShadow = '-1px 0 0 0 #ddd inset';
          tr.children[i].style.paddingRight = '6px';
        }
        if (index % 2 === 0) {
          bgColor = '#fff';
          if (index === 0 && tr.children[i].className.indexOf('headerSort') > -1) {
            bgColor = '#e2eff6';
          }
          tr.children[i].style.backgroundColor = bgColor;
        }
      }
    });
  }, 0);
};

$(window).on('load', () => { // on 'load' to allow link icons to load.
  horizontalScrollList();
  $(document).on('rails_admin.dom_ready', horizontalScrollList);
});

```