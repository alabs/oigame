
function draw_stats_chart(){
  var items_messages = JSON.parse($('#stats-data').text());
  var minimal_date = $("#stats-minimal_date").text();
  chart_draw(items_messages, 'chart_messages', '#F78181', minimal_date);
}
////////////////////////// switch_campaign_type - start 

function switch_campaign_type(ctype) {
  switch (ctype) {
    case "petition": 
      $(".form-campaign, .form-fax")
        .hide("slow");
      $("form-fax input, .form-fax textarea")
        .attr("required", "required");
      $(".form-campaign input, .form-campaign textarea, .form-fax input, .form-fax textarea")
        .removeAttr("required"); 
      break;
    case "mailing":
      $(".form-fax")
        .hide("slow");
      $(".form-campaign")
        .show("slow")
        .removeClass("hide");
      $(".form-fax input, .form-fax textarea")
        .removeAttr("required");
      $(".form-campaign input, .form-campaign textarea")
        .attr("required", "required");
      break;
    case "fax":
      $(".form-campaign")
        .hide("slow");
      $(".form-fax")
        .show("slow")
        .removeClass("hide");
      $(".form-campaign input, .form-campaign textarea")
        .removeAttr("required");
      $(".form-fax input, .form-fax textarea")
        .attr("required", "required");
      break;
    default:
      $(".form-campaign, .form-fax")
        .hide("slow");
      $(".form-campaign input, .form-campaign textarea, .form-fax input .form-fax textarea")
        .removeAttr("required"); 
      break;
  }
}
////////////////////////// switch_campaign_type - start 


////////////////////////// chart_draw: jqplot helper  - start

function chart_draw(items, chart_id, color, minimal_date){
  // seleccionamos el valor del ultimo item para saber cual tiene 
  // que ser el tickInterval 
  var last_item = items[items.length-1][1];
  if (last_item > 0){
    var tick_interval = Math.ceil(last_item / 4);
  } else {
    var tick_interval = 1;
  }
  $.jqplot(chart_id, [items], {
    seriesDefaults: {
      fill: true,
      fillAndStroke: true,
      fillAlpha: 0.5,
      shadow: false
    },
    highlighter: {
      tooltipAxes: 'y',
    },
    grid: {
        backgroundColor: 'white',
        borderColor: 'white',
        drawGridlines: false,
      shadow: false
    },
    axes: {
      xaxis: {
        label:'Fecha (Día-Mes)',
        labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
        renderer:$.jqplot.DateAxisRenderer,
        tickOptions:{formatString:'%d-%m'},
        min: minimal_date
      },
      yaxis: {
        min: 0,
        tickInterval: tick_interval,
        tickOptions:{
          formatString:'%d'
        },
        label:'Mensajes enviados',
        labelRenderer: $.jqplot.CanvasAxisLabelRenderer
      }
    },
    series: [{
      color: color,
      lineWidth:4
    }]
  }); 
}

////////////////////////// chart_draw: jqplot helper  - end



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

  // Al hacer click en unirse a una campaña, hacer el scroll
  // y poner foco en el campo nombre
  $("#join-this-campaign-link").click(function(event) {
    event.preventDefault();
    var fullUrl = this.href;
    var parts = fullUrl.split("#");
    var target = parts[1];
    var targetOffset = $("#"+target).offset();
    var targetTop = targetOffset.top;
    $("html, body").animate({scrollTop:targetTop}, 1000);
    $("#campaign-message-form #email").focus();
  }); 

  function copy_input_to_modal(input_id){
    $("#modal-send-message #" + input_id).val($("#show-campaign-sidebar #" + input_id).val());
  }

  var html_clean =  jQuery.trim( $("#modal-widget-window-example").html() );
  $("#modal-widget-html").text(html_clean);

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

  // thermometer start
  var participants = $("#participants").text();
  var participants_target = $("#participants-target").text();
  var percent_raw = (participants * 100) / participants_target;
  var percent = Math.round(percent_raw);
  $(".progress .bar").css("width", percent + "%")
  // thermometer end


  // al hacer click en /campaigns en cualquier campania va directamente a esta misma
  $(".mostrar-campaign").click( function(){
    var destination = $(this).children(".cinfo").children("h3").children("a").attr("href");
    window.location = destination;
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
      $.jqplot.config.enablePlugins = true;
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

});
