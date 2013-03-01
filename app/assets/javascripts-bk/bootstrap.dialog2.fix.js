
function __getOverlay(dialog) {
    return dialog.parent().prev(".modal-backdrop");
}


$( function(){
  // cierra el modal con la tecla ESC
  $(".modal").bind("keydown" ,function(event) {
    if (event.keyCode == "27") {
      var dialog = $(this).children(".modal-body");
      __getOverlay(dialog).hide();
      
      dialog
          .parent().hide().end()
          .trigger("dialog2.closed")
          .removeClass("opened");
    }
  });
});
