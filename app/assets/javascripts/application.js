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

  $("#sessions #user-login-session").click(function(e) {
    e.preventDefault();
    $("#login-form-ul").toggle();
    $("#email").focus();
  });

  $("#user-actions").click(function(e) {
    e.preventDefault();
    $("#user-actions-options").toggle();
  });
});
