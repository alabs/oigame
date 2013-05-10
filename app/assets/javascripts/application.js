//= require external
//= require_tree

$(function(){

  // edit-user clean password
  $("#user_edit #user_password").val("");

  hljs.initHighlightingOnLoad();

  $('.alert').hide().slideDown(1000).show();

  // activamos popups de ayuda
  $('[rel="popup_ayuda"]').popover({
    trigger: 'focus'
  });

  // todos los elementos con la clase editable se le añade el editor WYSIWYG
  $('.editable').mdmagick();

});
