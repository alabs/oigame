
////////////////////////// switch_campaign_type - start 

function switch_campaign_type(ctype) {
  switch (ctype) {
    case "petition": 
      $(".form-campaign, .form-fax, .form-call").hide("slow");
      $(".form-fax input, .form-fax textarea, .form-call textarea").attr("required", "required");
      $(".form-campaign input, .form-campaign textarea, .form-fax input, .form-fax textarea, .form-call textarea").removeAttr("required"); 
      break;
    case "mailing":
      $(".form-fax, .form-call").hide("slow");
      $(".form-campaign").show("slow").removeClass("hide");
      $(".form-fax input, .form-fax textarea, .form-call textarea").removeAttr("required");
      $(".form-campaign input, .form-campaign textarea").attr("required", "required");
      break;
    case "fax":
      $(".form-campaign, .form-call").hide("slow");
      $(".form-fax").show("slow").removeClass("hide");
      $(".form-campaign input, .form-campaign textarea, .form-call textarea").removeAttr("required");
      $(".form-fax input, .form-fax textarea").attr("required", "required");
      break;
    case "call":
      $(".form-campaign, .form-fax").hide("slow");
      $(".form-call").show("slow").removeClass("hide");
      $(".form-campaign input, .form-campaign textarea, .form-fax input, .form-fax textarea").removeAttr("required");
      $(".form-call textarea").attr("required", "required");
      break;
    default:
      $(".form-campaign, .form-fax, .form-call").hide("slow");
      $(".form-campaign input, .form-campaign textarea, .form-fax input .form-fax textarea, .form-call textarea").removeAttr("required"); 
      break;
  }
}
////////////////////////// switch_campaign_type - start 



////////////////////////// check_own_message  - start
function check_own_message($selector){
  // function que comprueba el checkbox de "Quiero escribir mi propio mensaje" 
  // muestra o esconde unos campos de formularios dependiendo de eso 
  if ( $selector.attr('checked') == "checked" ){
    $('.form-message')
      .slideDown('slow')
      .removeClass('hide');
    $('.form-message input, .form-message textarea').attr('required', 'required');
  } else {
    $('.form-message')
      .slideUp('slow')
      .addClass('hide');
    $('.form-message input, .form-message textarea').removeAttr('required');
  }
}

////////////////////////// check_own_message  - end


$(function() {

  $.datepicker.regional['es'] = {
    closeText: 'Cerrar',
prevText: '&#x3c;Ant',
nextText: 'Sig&#x3e;',
currentText: 'Hoy',
monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
'Jul','Ago','Sep','Oct','Nov','Dic'],
dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
weekHeader: 'Sm',
dateFormat: 'dd/mm/yy',
firstDay: 1,
isRTL: false,
showMonthAfterYear: false,
yearSuffix: ''};
  $.datepicker.setDefaults($.datepicker.regional['es']);

  $("#campaign_duedate_at").datepicker();

  $(".show_markdown_help").click( function(event){
    event.preventDefault();
    if ( $(this).hasClass("hide_markdown_help") ){
      $(this).text("ver ayuda de marcado");
      $(this).removeClass("hide_markdown_help");
    } else {
      $(this).addClass("hide_markdown_help");
      $(this).text("esconder ayuda de marcado");
    }
    $(this).next().fadeToggle("slow", "linear");
  });

  switch_campaign_type($('input[name="campaign[ttype]"]').filter(':checked').attr('value'));

  // /second: para ocultar o mostrar un field en función del select
  $('.campaign-ttype input').change( function(){
    switch_campaign_type($(this).attr('value'));
  });

  // comprueba si esta marcada la casilla de escribir el propio mensaje
  $('#own_message').bind('click', function(){
    check_own_message($(this));
  });

  check_own_message($('#own_message'));

  // mostrar stats al cambiar de tab
  $('a[data-toggle="tab"]').on('shown', function (e) {
    if ( $(this).attr('href') === "#stats" ){ 
      draw_stats_chart();
    };
  });

  // al darle al submit en el form, comprobamos el correo
  //$('#js-message-campaign').submit(function(e){
  //  var $form = $(this);
  //  var domains = ['hotmail.com', 'gmail.com', 'aol.com', 'yahoo.com'];
  //
  //  $('#js-message-check-email').mailcheck({ 
  //    domains: domains,
  //    suggested: function(element, suggestion) {
  //       notify("Hemos encontrado un error en tu correo, quizás quisiste decir " + suggestion.domain, "error");
  //       e.preventDefault(); //evitamos que el formulario se submitee
  //    },
  //    empty: function(element) { return true; }
  //  })
  //})

  $('#participate-buttons').scrollToFixed();

  $('#modal-notify-nocredit').modal({keyboard: true, backdrop: true});

  $('.js-campaign-description-show').on('click', function(e){
    e.preventDefault();
    $(this).hide();
    $('.js-campaign-description').slideDown('slow');
  });

  $('.js-modal-thanks').modal()

});
