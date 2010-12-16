jQuery(document).ready(function($) {
    function send_form(event) {
        $('#facebox #new_record_form').callRemote();
        event.preventDefault();
        return false;
    }

    
    $('.show_associated_record_form').bind("ajax:success", function(event, data, status, xhr){
        $.facebox(data);
    })

    $('.selectField').bind('update_with_new_element', function(event, option_value, option_name) {
        $(event.target).append('<option value="' + option_value + '">' + option_name + ' ' + option_value + '</option>' );
    });

    //$('#facebox #new_record_form').bind("ajax")

    $('#facebox input.save_button').live('click', send_form);

    $('#facebox input.cancel_button').live('click', function() {
        $.facebox.close();
        return false;
    });

    
});
