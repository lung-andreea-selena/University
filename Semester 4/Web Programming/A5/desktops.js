$(document).ready(function() {
    $('.desktop').first().show();

    $('.desktop').click(function() {
        var currentDesktop = $(this);
        var nextDesktop = currentDesktop.next('.desktop').length ? currentDesktop.next('.desktop') : $('.desktop').first();

        currentDesktop.animate({left: '-100vw'}, 500, function() {
            currentDesktop.hide();
            nextDesktop.css('left', '100vw').show().animate({left: 0}, 500);
        });
    });
});