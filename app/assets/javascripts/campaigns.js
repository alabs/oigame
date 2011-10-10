
////////////////////////// chart_draw: jqplot helper  - start

function chart_draw(items, chart_id, chart_title, color){
  $.jqplot(chart_id, [items], {
    title: chart_title,
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
        drawGridlines: false
    },
    axes: {
      xaxis: {
        label:'Fecha (Día-Mes)',
        labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
        renderer:$.jqplot.DateAxisRenderer,
        tickOptions:{formatString:'%d-%m'},
        tickInterval:'1 day'
      },
      yaxis: {
        label:'Cantidad',
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
    chart_draw(items_messages, 'chart_messages', 'Mensajes enviados', '#819FF7');
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
  console.log(percent_raw);
  var percent = Math.round(percent_raw);
  console.log(percent);
  $(".thermocontainer .mercury").css("width", percent)
  // thermometer end

});
