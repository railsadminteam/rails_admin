$(document).live 'rails_admin.dom_ready', ->

  if $('form').length # don't waste time otherwise

    # colorpicker

    $('form [data-color]').each ->
      that = this
      $(this).ColorPicker
        color: $(that).val()
        onShow: (el) ->
          $(el).fadeIn(500)
          false
        onHide: (el) ->
          $(el).fadeOut(500)
          false
        onChange: (hsb, hex, rgb) ->
          $(that).val(hex)
          $(that).css('backgroundColor', '#' + hex)

    # datetime

    $('form [data-datetimepicker]').each ->
      $(this).datetimepicker $(this).data('options')

    # enumeration

    $('form [data-enumeration]').each ->
      $(this).filteringSelect $(this).data('options')

    # fileupload

    $('form [data-fileupload]').each ->
      input = this
      $(this).find(".delete input[type='checkbox']").live 'click', ->
        $(input).children('.toggle').toggle('slow')

    # filtering-multiselect

    $('form [data-filteringmultiselect]').each ->
      $(this).filteringMultiselect $(this).data('options')
      if $(this).parents("#modal").length # hide link if we already are inside a dialog (endless issues on nested dialogs with JS)
        $(this).parents('.control-group').find('.btn').remove()
      else
        $(this).parents('.control-group').first().remoteForm()

    # filtering-select

    $('form [data-filteringselect]').each ->
      $(this).filteringSelect $(this).data('options')
      if $(this).parents("#modal").length # hide link if we already are inside a dialog (endless issues on nested dialogs with JS)
        $(this).parents('.control-group').find('.btn').remove()
      else
        $(this).parents('.control-group').first().remoteForm()

    # nested-many

    $('form [data-nestedmany]').each ->
      field = $(this).parents('.control-group').first()
      nav = field.find('> .controls > .nav')
      content = field.find('> .tab-content')
      toggler = field.find('> .controls > .btn-group > .toggler')
      # add each nested field to a tab-pane and reference it in the nav
      content.children('.fields:not(.tab-pane)').addClass('tab-pane').each ->
        nav.append('<li><a data-toggle="tab" href="#' + this.id + '">' + $(this).children('.object-infos').data('object-label') + '</a></li>')
      # only if no tab is set to active
      if nav.find("> li.active").length == 0
        # init first tab, toggler and content/tabs visibility
        nav.find("> li > a[data-toggle='tab']:first").tab('show')
      if nav.children().length == 0
        nav.hide()
        content.hide()
        toggler.addClass('disabled').removeClass('active').children('i').addClass('icon-chevron-right')
      else
        if toggler.hasClass('active')
          nav.show()
          content.show()
          toggler.children('i').addClass('icon-chevron-down')
        else
          nav.hide()
          content.hide()
          toggler.children('i').addClass('icon-chevron-right')

    # nested-one

    $('form [data-nestedone]').each ->
      field = $(this).parents('.control-group').first()
      nav = field.find("> .controls > .nav")
      content = field.find("> .tab-content")
      toggler = field.find('> .controls > .toggler')
      content.children(".fields:not(.tab-pane)").addClass('tab-pane').each ->
        nav.append('<li><a data-toggle="tab" href="#' + this.id + '">' + $(this).children('.object-infos').data('object-label') + '</a></li>')
      first_tab = nav.find("> li > a[data-toggle='tab']:first")
      first_tab.tab('show')
      field.find("> .controls > [data-target]:first").html('<i class="icon-white"></i> ' + first_tab.html())
      if toggler.hasClass('active')
        toggler.children('i').addClass('icon-chevron-down')
        content.show()
      else
        toggler.children('i').addClass('icon-chevron-right')
        content.hide()

    # polymorphic-association

    $('form [data-polymorphic]').each ->
      type_select = $(this)
      field = type_select.parents('.control-group').first()
      object_select = field.find('select').last()
      urls = type_select.data('urls')
      type_select.on 'change', (e) ->
        if $(this).val() is ''
          object_select.html('<option value=""></option>')
        else
          $.ajax
            url: urls[type_select.val()]
            data:
              compact: true
              all: true
            beforeSend: (xhr) ->
              xhr.setRequestHeader("Accept", "application/json")
            success: (data, status, xhr) ->
              html = '<option></option>'
              $(data).each (i, el) ->
                html += '<option value="' + el.id + '">' + el.label + '</option>'
              object_select.html(html)

    # ckeditor

    goCkeditors = (array) =>
      array.each (index, domEle) ->
        options = $(this).data
        if instance = window.CKEDITOR.instances[this.id]
            instance.destroy(true)
        window.CKEDITOR.replace(this, options['options'])
        $(this).addClass('ckeditored')

    array = $('form [data-richtext=ckeditor]').not('.ckeditored')
    if array.length
      @array = array
      if not window.CKEDITOR
        options = $(array[0]).data('options')
        window.CKEDITOR_BASEPATH = options['base_location']
        $.getScript options['jspath'], (script, textStatus, jqXHR) =>
          goCkeditors(@array)
      else
        goCkeditors(@array)

    #codemirror

    goCodeMirrors = (array) =>
      array.each (index, domEle) ->
        options = $(this).data('options')
        textarea = this
        $.getScript options['locations']['mode'], (script, textStatus, jqXHR) ->
          $('head').append('<link href="' + options['locations']['theme'] + '" rel="stylesheet" media="all" type="text\/css">')
          CodeMirror.fromTextArea(textarea,{mode:options['options']['mode'],theme:options['options']['theme']})
          $(textarea).addClass('codemirrored')

    array = $('form [data-richtext=codemirror]').not('.codemirrored')      
    if array.length
      @array = array
      if not window.CodeMirror
        options = $(array[0]).data('options')
        $('head').append('<link href="' + options['csspath'] + '" rel="stylesheet" media="all" type="text\/css">')
        $.getScript options['jspath'], (script, textStatus, jqXHR) =>
          goCodeMirrors(@array)
      else
        goCodeMirrors(@array)

