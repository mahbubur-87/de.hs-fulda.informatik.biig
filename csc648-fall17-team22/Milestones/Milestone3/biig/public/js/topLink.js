//TOP link code
          $('#back-to-top').tooltip('hide');
          $('#back-to-top').hide();
          $(window).scroll(function () {
                 if ($(this).scrollTop() > 50) {
                     $('#back-to-top').show();
                 } else {
                     $('#back-to-top').hide();
                 }
             });
             // scroll body to 0px on click
             $('#back-to-top').click(function () {
                 $('#back-to-top').tooltip('hide');
                 $('body,html').animate({
                     scrollTop: 0
                 }, 800);
                 return false;
             });
