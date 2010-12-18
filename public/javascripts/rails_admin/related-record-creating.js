jQuery(document).ready(function($) {
    function send_form(event) {
        event.preventDefault();
        $('#facebox form').callRemote();
    }

    
    $('.showAssociatedRecordForm').bind("ajax:success", function(event, data, status, xhr){
        $.facebox(data);
    })

    $('.selectField').bind('updateWithNewElement', function(event, option_value, option_name) {
        $(event.target).append('<option value="' + option_value + '">' + option_name + '</option>' );
    });

    //$('#facebox #new_record_form').bind("ajax")

    $('#facebox input[name=_save]').live('click', send_form);

    $('#facebox input[name=_continue]').live('click', function(event) {
        event.preventDefault();
        $.facebox.close();
    });

    
});
