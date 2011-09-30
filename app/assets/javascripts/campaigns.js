////////////////////////// chart_draw: jqplot helper  - start

function chart_draw(items, chart_id, chart_title, color){
  $.jqplot(chart_id, [items], {
    title: chart_title,
    highlighter: {
      tooltipAxes: 'y',
    },
    grid: {
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


  ////////////////////////// modal-stats-window start
  $.jqplot.config.enablePlugins = true;

  // comprobamos que se encuentre la data
  if ( $('#stats-data').text().length != 0 ) {
    var items_messages = JSON.parse($('#stats-data').text());
    chart_draw(items_messages, 'chart_messages', 'Mensajes enviados', 'red');
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

  $("#show-modal-widget").click(function(event) {
    $("#modal-widget-window").parent().addClass("modal-large");
    event.preventDefault();
    $("#modal-widget-window").dialog2("open");
  });
  // modal-widget end

  // comment-form floating start
  $('#show-campaign-sidebar').scrollToFixed({
    marginTop:
      $('#header').outerHeight() + 10,
    limit:
      $('#integrate-this-campaign').offset().top - $('#show-campaign-sidebar').outerHeight() - 10
  });
  // comment-form floating end
  
});