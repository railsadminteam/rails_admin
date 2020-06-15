(function($) {
  $(document).ready(function() {
    return window.nestedFormEvents.insertFields = function(content, assoc, link) {
      var tab_content;
      tab_content = $(link).closest(".controls").siblings(".tab-content");
      tab_content.append(content);
      return tab_content.children().last();
    };
  });

  $(document).on('nested:fieldAdded', 'form', function(content) {
    var controls, field, nav, new_tab, one_to_one, parent_group, toggler;
    field = content.field.addClass('tab-pane').attr('id', 'unique-id-' + (new Date().getTime()));
    new_tab = $('<li></li>').append(
        $('<a></a>').attr('data-toggle', 'tab').attr('href', '#' + field.attr('id')).text(field.children('.object-infos').data('object-label'))
    )
    parent_group = field.closest('.control-group');
    controls = parent_group.children('.controls');
    one_to_one = controls.data('nestedone') !== void 0;
    nav = controls.children('.nav');
    content = parent_group.children('.tab-content');
    toggler = controls.find('.toggler');
    nav.append(new_tab);
    $(window.document).trigger('rails_admin.dom_ready', [field, parent_group]);
    new_tab.children('a').tab('show');
    if (!one_to_one) {
      nav.select(':hidden').show('slow');
    }
    content.select(':hidden').show('slow');
    toggler.addClass('active').removeClass('disabled').children('i').addClass('icon-chevron-down').removeClass('icon-chevron-right');
    if (one_to_one) {
      controls.find('.add_nested_fields').removeClass('add_nested_fields').text(field.children('.object-infos').data('object-label'));
    }
  });

  $(document).on('nested:fieldRemoved', 'form', function(content) {
    var add_button, controls, current_li, field, nav, one_to_one, parent_group, toggler;
    field = content.field;
    nav = field.closest(".control-group").children('.controls').children('.nav');
    current_li = nav.children('li').has('a[href="#' + field.attr('id') + '"]');
    parent_group = field.closest(".control-group");
    controls = parent_group.children('.controls');
    one_to_one = controls.data('nestedone') !== void 0;
    toggler = controls.find('.toggler');
    (current_li.next().length ? current_li.next() : current_li.prev()).children('a:first').tab('show');
    current_li.remove();
    if (nav.children().length === 0) {
      nav.select(':visible').hide('slow');
      toggler.removeClass('active').addClass('disabled').children('i').removeClass('icon-chevron-down').addClass('icon-chevron-right');
    }
    if (one_to_one) {
      add_button = toggler.next();
      add_button.addClass('add_nested_fields').html(add_button.data('add-label'));
    }
    field.find('[required]').each(function() {
      $(this).removeAttr('required');
    });
  });
}(jQuery));
