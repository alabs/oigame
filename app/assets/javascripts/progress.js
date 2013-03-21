
// TODO: hacer una libreria con esto, para el jquery.progressmooth.js 

// progreso smooth en la barra de progreso :)

// options
// where to print the value -> $('selector')
// where to print the restant value -> $('selector')


function progressCounter($selector,value,recipients_count,max,speed) {
  setTimeout(function() { 
    $selector.attr('value', value * recipients_count); 
    $('.js-collected .highlighted').text(value * recipients_count);
    $('.js-participated-people .underlined').text(value);
    $('.js-needed-people .underlined').text(max - value);
  }, speed * value);
}

function progressGetSpeed(value) {
  // FIXME: this sucks - think another algorithm for doing this.
  var result;

  switch (true) {
    case (value == 0):
      result = 0;
      break;

    case (value <= 100):
      result = 200;
      break;

    case ((value >= 100) && (value <= 500)):
      result = 25;
      break;

    case ((value >= 500) && (value <= 1000)):
      result = 7;
      break;

    case ((value >= 1000) && (value <= 5000)):
      result = 3;
      break;

    case (value >= 5000):
      result = 0;
      break;

    default:
      result = 1;
      break;
  }

  return result;
}

function progressInit($selector) {
  var value = parseInt($selector.attr('value'));
  var max = parseInt($selector.attr('max'));
  var recipients_count = parseInt($selector.attr('data-recipients-count'));
  var speed = progressGetSpeed(value);

  $selector.attr('value', 0); 
  for (var i=1;i<value+1;i++) progressCounter($selector,i,recipients_count,max,speed)

}

$(function(){

   progressInit($('progress#bar'));

});
