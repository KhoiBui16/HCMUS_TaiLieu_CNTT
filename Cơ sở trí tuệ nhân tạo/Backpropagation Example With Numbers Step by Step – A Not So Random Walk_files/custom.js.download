/**
 * File custom.js.
 *
 * Theme Customizer enhancements for a better user experience.
 *
 * Contains handlers to make Theme Customizer preview reload changes asynchronously.
 */

(function($){

    //--------------------------------------------------------- Menu ---------------------------------------------------------//

    //Desktop dot

    $( ".io-menu-desktop li" ).has( "ul" ).find('>a').addClass('io-menu-dot-desktop');

    //Desktop button

    var io_menu_desktop = $( ".io-menu-desktop" );
    io_menu_desktop.find('>ul, >*>ul').append( '<li class="io-menu-button io-menu-button-li" ><a href="#">≡</a></li>' );
    io_menu_desktop.prepend( '<span class="io-menu-button io-menu-button-span" >≡</span>' );

    //Switch menu Desktop-Mobile

    var io_menu = $(".io-menu");
    var io_arr_temp_width = [];
    var io_i =0;

    io_menu.map(function () {

        //Get and Set width menu full width

        //For menu H
        if(!$(this).hasClass('io-menu-desktop-vr')&&!$(this).hasClass('io-menu-desktop-vl')){
            $(this).addClass('io-get-width-menu');
        }
        var first_point = $('>ul>li:first-child, >*>ul>li:first-child', this)[0].getBoundingClientRect();
        var last_point = $('>ul>li:last-child, >*>ul>li:last-child', this)[0].getBoundingClientRect();
        io_arr_temp_width[io_i] = Math.ceil(last_point.right-first_point.left);

        //For menu VL & VR - fix width 1024
        if(($(this).hasClass('io-menu-desktop-vr')||$(this).hasClass('io-menu-desktop-vl'))&&io_arr_temp_width[io_i]<1024){
            io_arr_temp_width[io_i]=1024;
        }
        $(this).removeClass('io-get-width-menu');


        //Set desktop-mobile - fisttime load

        //For menu H
        if( !$(this).hasClass('io-menu-desktop-vr') && !$(this).hasClass('io-menu-desktop-vl') ){
            if ( $(this).width() <= io_arr_temp_width[io_i] && $(this).hasClass('io-menu-desktop') ){
                $(this).addClass('io-menu-mobile').removeClass('io-menu-desktop');
            }
        }
        //For menu VL & VR
        else {
            if ( $(window).width() < io_arr_temp_width[io_i] && $(this).hasClass('io-menu-desktop') ){
                $(this).addClass('io-menu-mobile').removeClass('io-menu-desktop');
            }
        }

        io_i++;

    });

    $( window ).resize(function() {

        //Set desktop-mobile - window resize

        var io_n =0;
        io_menu.map(function () {

            //For menu H
            if( !$(this).hasClass('io-menu-desktop-vr') && !$(this).hasClass('io-menu-desktop-vl') ){
                if ( $(this).width()>io_arr_temp_width[io_n] && $(this).hasClass('io-menu-mobile') ) {
                    $(this).addClass('io-menu-desktop').removeClass('io-menu-mobile');
                }
                else if ( $(this).width() <= io_arr_temp_width[io_n] && $(this).hasClass('io-menu-desktop') ){
                    $(this).addClass('io-menu-mobile').removeClass('io-menu-desktop');
                }
            }

            //For menu VL & VR
            else {
                if ( $(window).width()>=io_arr_temp_width[io_n] && $(this).hasClass('io-menu-mobile') ) {
                    $(this).addClass('io-menu-desktop').removeClass('io-menu-mobile');
                }
                else if ( $(window).width() < io_arr_temp_width[io_n] && $(this).hasClass('io-menu-desktop') ){
                    $(this).addClass('io-menu-mobile').removeClass('io-menu-desktop');
                }
            }

            io_n++;
        });
    });

    $( ".io-menu-button" ).click(function() {
        if ($(this).parent().hasClass('io-menu')&&$(this).parent().hasClass('io-menu-desktop')) {
            $(this).parent().addClass('io-menu-desktop-temp');
            $(this).parent().removeClass('io-menu-desktop');
            $(this).parent().addClass('io-menu-mobile');
            $(this).parent().addClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).addClass('iot-menu-bg-black-active');
        }else if ($(this).parent().hasClass('io-menu')&&$(this).parent().hasClass('io-menu-desktop-temp')) {
            $(this).parent().addClass('io-menu-desktop');
            $(this).parent().removeClass('io-menu-desktop-temp');
            $(this).parent().removeClass('io-menu-mobile');
            $(this).parent().removeClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).removeClass('iot-menu-bg-black-active');
        }else
        if ($(this).parent().parent().parent().hasClass('io-menu')&&$(this).parent().parent().parent().hasClass('io-menu-desktop')) {
            $(this).parent().parent().parent().addClass('io-menu-desktop-temp');
            $(this).parent().parent().parent().removeClass('io-menu-desktop');
            $(this).parent().parent().parent().addClass('io-menu-mobile');
            $(this).parent().parent().parent().addClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).addClass('iot-menu-bg-black-active');
        }else if ($(this).parent().parent().parent().hasClass('io-menu')&&$(this).parent().parent().parent().hasClass('io-menu-desktop-temp')) {
            $(this).parent().parent().parent().addClass('io-menu-desktop');
            $(this).parent().parent().parent().removeClass('io-menu-desktop-temp');
            $(this).parent().parent().parent().removeClass('io-menu-mobile');
            $(this).parent().parent().parent().removeClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).removeClass('iot-menu-bg-black-active');
        }else

        if ($(this).parent().hasClass('io-menu')&&$(this).parent().hasClass('io-menu-mobile')&&!$(this).parent().hasClass('io-menu-mobile-active')) {
            $(this).parent().addClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).addClass('iot-menu-bg-black-active');
        }else if ($(this).parent().hasClass('io-menu')&&$(this).parent().hasClass('io-menu-mobile-active')) {
            $(this).parent().removeClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).removeClass('iot-menu-bg-black-active');
        }else
        if ($(this).parent().parent().parent().hasClass('io-menu')&&$(this).parent().parent().parent().hasClass('io-menu-mobile')&&!$(this).parent().parent().parent().hasClass('io-menu-mobile')) {
            $(this).parent().parent().parent().addClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).addClass('iot-menu-bg-black-active');
        }else if ($(this).parent().parent().parent().hasClass('io-menu')&&$(this).parent().parent().parent().hasClass('io-menu-mobile-active')) {
            $(this).parent().parent().parent().removeClass('io-menu-mobile-active');
            $( '.iot-menu-bg-black' ).removeClass('iot-menu-bg-black-active');
        }

        //Set height for dor menu Mobile - Should Fix css transition:.2s of a tag = setTimeout or set transition by JS addClass to body
        //setTimeout(function () {
            var a_height = $( ".io-menu-mobile ul a:first-child" ).outerHeight();
            $( ".io-menu ul .io-menu-dot-mobile" ).height(a_height);
            $( ".io-menu ul .io-menu-dot-mobile" ).css('line-height',a_height+'px');
        //},250);
    });

    $( "body" ).append( '<div class="iot-menu-bg-black" ></div>' );

    $( ".iot-menu-bg-black" ).click(function() {
        $( '.io-menu-mobile-active' ).removeClass('io-menu-mobile-active');
        $( '.io-menu-desktop-temp' ).addClass('io-menu-desktop');
        $( '.io-menu-desktop-temp' ).removeClass('io-menu-mobile');
        $( '.io-menu-desktop-temp' ).removeClass('io-menu-desktop-temp');
        $( '.iot-menu-bg-black' ).removeClass('iot-menu-bg-black-active');
    });

    //Add CSS for dot menu Mobile

    $( ".io-menu ul ul" ).addClass('io-mobile-ul-hide');
    $( ".io-menu li" ).has( "ul" ).prepend( '<span class="io-menu-dot-mobile">+</span>' );
    $( ".io-menu-dot-mobile" ).click(function() {

        if ($(this).parent().hasClass('io-fadein-mobile')) {
            $(this).parent().removeClass('io-fadein-mobile');
        }else{
            $(this).parent().addClass('io-fadein-mobile');
        }

        if ($(this).text()=='+') {
            $(this).text('-');
        }else
        if($(this).text()=='-') {
            $(this).text('+');
        }

        if ($(this).parent().find('>ul, >*>ul').css('left')=='-9999px') {
            $(this).parent().find('>ul, >*>ul').addClass('io-mobile-ul-show');
            $(this).parent().find('>ul, >*>ul').removeClass('io-mobile-ul-hide');
        }else
        if ($(this).parent().find('>ul, >*>ul').css('left')=='0px') {
            $(this).parent().find('>ul, >*>ul').addClass('io-mobile-ul-hide');
            $(this).parent().find('>ul, >*>ul').removeClass('io-mobile-ul-show');
        }

    });

    //--------------------------------------------------------- textFit ---------------------------------------------------------//

    // function io_text_check_fit(ne){
    //     ne.each(function () {
    //         $(this).prepend('<span class="spanst"></span>');
    //         $(this).append('<span class="spannd"></span>');
    //
    //         $(this).addClass('io-get-width-textfit');
    //
    //         first_point = $('.spanst', this)[0].getBoundingClientRect();
    //         last_point = $('.spannd', this)[0].getBoundingClientRect();
    //         temp_width = last_point.left - first_point.right;
    //
    //         $(this).removeClass('io-get-width-textfit');
    //
    //         if (parseFloat( $(this).css('font-size' ).match(/\d+/) )===0) {
    //             $(this).css('font-size','1px' )
    //         }
    //
    //         font_size_first = parseFloat( $(this).css('font-size' ).match(/\d+/) );
    //         font_set = ( (font_size_first*$(this).width())/temp_width );
    //         font_set_string = font_set.toString();
    //
    //         $(this).css('font-size', font_set_string + 'px');
    //
    //         first_point = $('.spanst', this)[0].getBoundingClientRect();
    //         last_point = $('.spannd', this)[0].getBoundingClientRect();
    //         temp_height = last_point.top - first_point.top;
    //
    //         if(temp_height!=0){
    //             font_set -= 0.1;
    //             font_set_string = font_set.toString();
    //             $(this).css('font-size', font_set_string + 'px');
    //             io_text_check_fit($(this));
    //         }
    //
    //         $('.spanst', this).remove();
    //         $('.spannd', this).remove();
    //     });
    // }
    //
    // function textFit(e, min=0, max=0) {
    //     setTimeout(function () {
    //         windowWidth = window.innerWidth+17;
    //         if(min===0 && max===0){
    //             io_text_check_fit(e);
    //         }else
    //         if(min>0 && max>0 && min<max){
    //             if (min>windowWidth||windowWidth>max) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }else
    //         if(min>0 && max===0){
    //             if (min>windowWidth) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }else
    //         if(max>0 && min===0){
    //             if (max<windowWidth) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }
    //     },200);
    //
    //     $(window).resize(function () {
    //         windowWidth = window.innerWidth+17;
    //         if(min===0 && max===0){
    //             io_text_check_fit(e);
    //         }else
    //         if(min>0 && max>0 && min<max){
    //             if (min>windowWidth||windowWidth>max) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }else
    //         if(min>0 && max===0){
    //             if (min>windowWidth) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }else
    //         if(max>0 && min===0){
    //             if (max<windowWidth) {
    //                 e.removeAttr('style');
    //             }else {
    //                 io_text_check_fit(e);
    //             }
    //         }
    //     });
    // }
    //
    // $(document).ready(function () {
    //
    //         // textFit( selecter, minWidth, maxWidth );
    //         textFit( $('.fittext') );
    // });

    //--------------------------------------------------------- Other JS ---------------------------------------------------------//

})(jQuery);