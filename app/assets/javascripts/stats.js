// https://github.com/flot/flot/blob/master/API.md
// http://people.iola.dk/olau/flot/examples/time.html
// http://people.iola.dk/olau/flot/examples/interacting.html

////////////////////////// chart_draw: jquery.flot helper  - start

function showTooltip(x, y, contents) {
  $('<div id="tooltip">' + contents + '</div>').css( {
    position: 'absolute',
  display: 'none',
  top: y + 5,
  left: x + 5,
  border: '1px solid #fdd',
  padding: '2px',
  'background-color': 'lightgrey',
  opacity: 0.80
  }).appendTo("body").fadeIn(200);
}

function chart_draw(stats_data){

  // jQuery Flot Chart

  $.plot($("#js-stats-chart"),
      [ { data: stats_data, label: "Participantes"}], {
        series: {
          lines: { show: true, lineWidth: 1, fill: true, fillColor: { colors: [ { opacity: 0.1 }, { opacity: 0.13 } ] } },
  points: { show: true, lineWidth: 2, radius: 3 },
  shadowSize: 0,
  stack: true
        },
  grid: { hoverable: true, clickable: true, tickColor: "#f9f9f9", borderWidth: 0 },
  legend: { show: true, labelBoxBorderColor: "#fff" },  
  colors: ["#EB5E40"],
  xaxis: {
    mode: "time",
  timeformat: "%d/%m/%Y",
  show: true,
  font: { family: "Open Sans, Arial", variant: "small-caps", color: "#9da3a9" }
  },
  yaxis: { ticks:3, tickDecimals: 0, font: {size:12, color: "#9da3a9"} }
      });

  $("#js-stats-chart").bind("plothover", function (event, pos, item) {
    $("#x").text(pos.x.toFixed(2));
    $("#y").text(pos.y.toFixed(2));

    if (item) {
      if (previousPoint != item.dataIndex) {
        previousPoint = item.dataIndex;

        $("#tooltip").remove();
        var y = item.datapoint[1];

        showTooltip(item.pageX, item.pageY,y);
      }
    }
    else {
      $("#tooltip").remove();
      previousPoint = null;            
    }
  });


}

////////////////////////// chart_draw: jquery.flot helper  - end

function draw_stats_chart(){
  var stats_data = JSON.parse($('#js-stats-data').text());
  var minimal_date = $("#stats-minimal_date").text();
  chart_draw(stats_data);
}

