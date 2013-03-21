
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
      break;
    case "tutorial":
      navbar_change('header-tutorial');
      break;
  }
}
////////////////////////// check-current-navbar start

$(function() {

  $("#user_email").focus();
  $("#campaign_name").focus();
  $("#contact_name").focus();

  // dropdown de seleccion de idioma
  var lang = $('#js-language-selector').data('lang');
  $('option[data-lang="' + lang + '"]').attr('selected', 'selected');

  $('#js-language-selector').change( function(){
    document.location.href = $(this).val();  
  });
 
  //check_current_navbar(document.URL.split('/')[4]);

});
