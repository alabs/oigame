
// progreso smooth en la barra de progreso :)
function progressCounter(v,max) {
  setTimeout(function() { 
    $('progress').attr('value', v); 
    $('#recogidas .highlighted').text(v);
    $('#necesarias .underlined').text(max - v);
  }, 10 * v);
}

$(function(){
  var value = parseInt($('progress').attr('value'));
  var max = parseInt($('progress').attr('max'));

  $('progress').attr('value', 0);

  for (var i=1;i<value+1;i++) {
    progressCounter(i,max); 
  }

});
