//= require external
//= require_tree
    
$(function(){

  // edit-user clean password
  $("#user_edit #user_password").val("");

  var isInIFrame = (window.location != window.parent.location) ? true : false;
  if (isInIFrame) {
    $("#corner").hide();
    $("#navbar").hide();
    $("#links-wrapper").hide();
    $("#footer-wrapper").hide();
    $("#page").css("width", "inherit").addClass("grid_3");
    $("#page-info").css("width", "240px");
    $("#page-wrapper")
      .css("padding-bottom", "125px").css("padding-left", "1px");
    $("#page-wrapper #page #page-info").css("border-right", "none");
    $("#logo a img")
      .css("margin-bottom", "1em")
      .css("margin-left", "2em")
      .css("margin-top", "2em");
  }

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

});
