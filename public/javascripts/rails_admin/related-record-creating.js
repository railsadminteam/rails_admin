jQuery(document).ready(function($) {
    function send_form(event) {
        $('#facebox #new_record_form').bind("ajax:success", function(event, data, status, xhr){
            $.facebox(data);
        })
        $('#facebox #new_record_form').callRemote();
        event.preventDefault();
        return false;
    }

    
    $('#show_associated_record_form').bind("ajax:success", function(event, data, status, xhr){
        $.facebox(data);
    })

    $('#facebox #new_record_form').bind("ajax")

    $('#facebox input#save_btn').live('click', send_form);

    
});
