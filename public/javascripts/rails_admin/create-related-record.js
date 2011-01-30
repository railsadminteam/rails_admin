jQuery(document).ready(function($) {
    function send_form(event) {
        event.preventDefault();
        $('#facebox .createRelatedDialog form').callRemote();
    }
    
    $('.showAssociatedRecordForm').bind("ajax:success", function(event, data, status, xhr){
        $.facebox(data, 'createRelatedDialog');
    })

    // TODO: refactor
    // now it is using method prepareManySelector, that use prototype
    $(document).bind("reveal.facebox", function() { prepareManySelectors() });
    
    $('.selectField').bind('updateWithNewElement', function(event, option_value, option_name) {
        $(event.target).append('<option value="' + option_value + '">' + option_name + '</option>' );
    });

    $('#facebox .createRelatedDialog input[name=_save]').live('click', send_form);

    $('#facebox .createRelatedDialog input[name=_continue]').live('click', function(event) {
        event.preventDefault();
        $.facebox.close();
    });

    
});
