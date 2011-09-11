// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {

  $("#flash-messages").delay(15000).fadeOut();

  $("#flash-messages a.close").click(function() {
    $("#flash-messages").toggle();
  });

  $("#sessions .dropdown-toggle").click(function() {
    $(".dropdown-menu").toggle();
    $("#username_or_email").focus();
  });

  $(document).mouseup(function(e) {
    if($(e.target).parent("#sessions .dropdown-toggle").length==0) {
      $(".dropdown-menu").hide();
    }
  });
});
