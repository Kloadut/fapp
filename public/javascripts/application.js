// Javascript of FAPP

$(document).ready(function() {

    // Captcha handling
    if($("#captcha1").length) {
        result = parseInt($("#captcha1").val()) + parseInt($("#captcha2").val())
        $("#captcha1").before('<input type="hidden" name="captcha" value="'+ result.toString() +'">');
        $("#captcha1").remove();
        $("#captcha2").remove();
    }

});
