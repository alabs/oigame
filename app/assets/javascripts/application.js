//= require external
//= require_tree

$(function(){

  // edit-user clean password
  $("#user_edit #user_password").val("");

  ///////////////////////// slideshow slogans - start
  simpleSlide({"status_width": 50  });

  $('.auto-slider').each( function() {
    var related_group = $(this).attr('rel');
    window.setInterval("simpleSlideAction('.right-button', " + related_group + ");", 10000);
  }); 
  ///////////////////////// slideshow slogans - end

  hljs.initHighlightingOnLoad();

  $(".multiselect").multiSelect({
    selectableHeader: '<h4>Todos los usuarios</h4>',
    selectedHeader: '<h4>Admins</h4>'
  });
  
  // para el slideshow de la home
  $("#myHomeCarousel .item:first").addClass("active");

  $('.alert').hide().slideDown(1000).show();

  // activamos popups de ayuda
  $('[rel="popup_ayuda"]').popover({
    trigger: 'focus'
  });

  // todos los elementos con la clase editable se le añade el editor WYSIWYG
  $('.editable').mdmagick();

});
