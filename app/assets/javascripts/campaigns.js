
////////////////////////// switch_campaign_type - start 

function switch_campaign_type(ctype) {
  switch (ctype) {
    case "petition": 
      $("#crecipients").hide("slow");
      $("#campaign_recipients").removeAttr("required"); 
      break;
    case "mailing":
      $("#crecipients").show("slow");
      $("#crecipients").removeClass("hide");
      $("#campaign_recipients").attr("required", "required");
      break;
    default:
      $("#crecipients").hide('slow');
      break;
  }
}
////////////////////////// switch_campaign_type - start 

////////////////////////// jquery.DatePicker cutomizations - start

$.dpText = {
  TEXT_PREV_YEAR    : 'Año anterior',
  TEXT_PREV_MONTH   : 'Mes anterior',
  TEXT_NEXT_YEAR    : 'Próximo año',
  TEXT_NEXT_MONTH   : 'Próximo mes',
  TEXT_CLOSE      : 'Cerrar',
  TEXT_CHOOSE_DATE: '',
  HEADER_FORMAT   : 'mmmm yyyy'
}

////////////////////////// jquery.DatePicker cutomizations - end

////////////////////////// chart_draw: jqplot helper  - start

function chart_draw(items, chart_id, color, minimal_date){
  // seleccionamos el valor del ultimo item para saber cual tiene 
  // que ser el tickInterval 
  var last_item = items[items.length-1][1];
  var tick_interval = Math.ceil(last_item / 4);
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

$(function() {

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

  ////////////////////////// modal-send-message start
  $("#modal-send-message").dialog2({
    removeOnClose: false,
    modal: true,
    autoOpen: false
  });
  
  function copy_input_to_modal(input_id){
    $("#modal-send-message #" + input_id).val($("#show-campaign-sidebar #" + input_id).val());
  }

  $("#show-modal-send-message").click(function(event) {
    event.preventDefault();
    $("#modal-campaign-message-form").html($("#campaign-message-form").html());
    $("#modal-send-message").parent().addClass("modal-large");
    $("#modal-campaign-message-form .form-actions").hide();
    $("#modal-campaign-message-form .form-field").addClass('clearfix').removeClass('form-field');
    $("#modal-campaign-message-form .span5").addClass('span9').removeClass('span5');
    $("#modal-campaign-message-form input, #modal-campaign-message-form textarea").wrap('<div class="input" />');
    copy_input_to_modal('email'); 
    copy_input_to_modal('subject'); 
    copy_input_to_modal('body'); 
    $(".modal-send-form").click( function(){ $("#modal-campaign-message-form form").submit() } );
    $("#modal-send-message").dialog2("open");
  });
  ////////////////////////// modal-send-message end


  ////////////////////////// modal-stats-window start
  $.jqplot.config.enablePlugins = true;

  // comprobamos que se encuentre la data
  if ( $('#stats-data').text().length != 0 ) {
    var items_messages = JSON.parse($('#stats-data').text());
    var minimal_date = $("#stats-minimal_date").text();
    chart_draw(items_messages, 'chart_messages', '#F78181', minimal_date);
  }

  $("#modal-stats-window").dialog2({
    removeOnClose: false,
    modal: true,
    autoOpen: false
  });

  $("#show-modal-stats-window").click(function(event) {
    event.preventDefault();
    $("#modal-stats-window").dialog2("open");
  });
  ////////////////////////// modal-stats-window end
  
  // modal-widget start
  $("#modal-widget-window").dialog2({
    removeOnClose: false,
    autoOpen: false
  });

  var html_clean =  jQuery.trim( $("#modal-widget-window-example").html() );
  $("#modal-widget-html").val(html_clean);

  $("#show-modal-widget").click(function(event) {
    $("#modal-widget-window").parent().addClass("modal-large");
    event.preventDefault();
    $("#modal-widget-window").dialog2("open");
  });
  // modal-widget end

//  if ( $("#campaign-actions").length > 0 ) {
//    // comment-form floating start
//    $('#show-campaign-sidebar').scrollToFixed({
//      marginTop:
//        $('#header').outerHeight() + 10,
//      limit:
//        $('#campaign-actions').offset().top - $('#show-campaign-sidebar').outerHeight() - 10
//    });
//    // comment-form floating end
//  }

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
  $(".thermocontainer .mercury").css("width", percent + "%")
  // thermometer end

  $('#campaign_duedate_at').datePicker({clickInput:true})

  // al hacer click en /campaigns en cualquier campania va directamente a esta misma
  $(".campaign-info").click( function(){
    var destination = $(this).children(".cinfo").children("h3").children("a").attr("href");
    window.location = destination;
  });

  var ctype_old = $("#campaign_ttype").val() 
  switch_campaign_type(ctype_old);

  // para ocultar o mostrar un field en función del select
  $("#campaign_ttype").change(function() {
    var ctype_new = $(this).val();
    switch_campaign_type(ctype_new);
  });

});
