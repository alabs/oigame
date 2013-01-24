
function navbar_change(section){
  $('.nav li').removeClass('active');
  $('#' + section).addClass('active');
}

function check_current_navbar(section){ 
  // comprueba en que URL nos encontramos y dependiendo de eso marca con .active
  // un link del header
  //
  // TODO: mover al controlador, esto es una guarrada
  if ( section.split("#")[1] ) {
    var query = section.split("#")[1];
  }
  var section = section.split("#")[0];
  switch (section) {
    case "campaigns": 
      navbar_change('header-campaigns');
      break;
    case "about":
      navbar_change('header-about');
      break;
    case "contact":
      navbar_change('header-contact');
      break;
    case "users":
      break;
    case "donate":
      navbar_change('header-donate');
      break;
    case "faq":
      navbar_change('header-faq');
      break;
    case "help":
      navbar_change('header-help');
      // $("#header-home").removeClass("active");
      // $("#header-help").addClass("active");
      // generateTOC("#preguntas");
      // if (query) { goTo(query); }
      break;
    case "tutorial":
      navbar_change('header-tutorial');
      // $("#header-home").removeClass("active");
      // $("#header-tutorial").addClass("active");
      // generateTOC("#tutorial");
      // if (query) { goTo(query); }
      break;
  }
}
////////////////////////// check-current-navbar start
//
function notify(message, theme){
  $.jGrowl(message, { 
    sticky: true, 
    theme: "flash-" + theme,
    closerTemplate: '<div>[ cerrar notificaciones ]</div>',
    open: function() { $(this).click( function(){ $(this).fadeOut(); }) }
  });
}


//
$(function() {

  // mensajes de flash, para que se muestren con jGrowl automaticamente
  $(".flash-messages").each(function() {
    var msg = $(this).children("p");
    var theme = $(this).children("p").attr("class");
    notify(msg.text(), theme)
  });

  // Para la barra de navegación del login
  // cuando no se está desconectado
  $(".signin").click(function(e) {
    e.preventDefault();
    $("fieldset#signin-menu").toggle();
  });

  $("fieldset#signin-menu").mouseup(function() {
    return false;
  });

  $(document).mouseup(function(e) {
    if ($(e.target).parent("a.signin").length==0) {
      $("fieldset#signin-menu").hide();
    }
  });
  
  $("#user_email").focus();
  $("#campaign_name").focus();
  $("#contact_name").focus();

  $('#js-language-selector').change( function(){
    document.location.href = $(this).val();  
  });
 
  $('.sidefirma').scrollToFixed();

  check_current_navbar(document.URL.split('/')[4]);

});
