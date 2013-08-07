// PARA LA HOME

// http://www.simonwhatley.co.uk/parsing-twitter-usernames-hashtags-and-urls-with-javascript

/* Con el nuevo sistema los hastag ya vienen como enlaces

String.prototype.parseURL = function() {
  return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&~\?\/.=]+/g, function(url) {
    return url.link(url);
  });
};

String.prototype.twParseUsername = function() {
  return this.replace(/[@]+[A-Za-z0-9-_]+/g, function(u) {
    var username = u.replace("@","")
    return u.link("http://twitter.com/"+username);
  });
};

String.prototype.twParseHashtag = function() {
  return this.replace(/[#]+[a-zA-Z0-9ßÄÖÜäöüÑñÉéÈèÁáÀàÂâŶĈĉĜĝŷÊêÔôÛûŴŵ-]+/g, function(t) {
    var tag = t.replace("#","%23")
    return t.link("http://twitter.com/search?q="+tag+"&src=hash");
  });
};

*/

// Con la nueva API 1.1 acceder al user_timeline requiere autentificación (habrá q mudarse a identi.ca)
// Solución inpirada en http://codepen.io/jasonmayes/pen/Ioype en base a parsear el widget oficial.
// Debe activarse en la cuenta.
$(function () {
  $.ajax({
    url: "https://cdn.syndication.twimg.com/widgets/timelines/365141264582201344",
    dataType: "jsonp",
    success: function (pag) {
      $('#twitter').html($(pag.body).find('.e-entry-title'));
		$('#twitter>p.e-entry-title').carrusel();
    }
  });
});


// PARA EL TAB DE TWITTER EN UNA CAMPAIGN

$(function () {
  if($('#js-campaign-hashtag').length == 1){
    $('#js-social-tw').jtwt({
      count: 20, // The number of displayed tweets.
      convert_links: true, //Converts hashtags to links
      query: $('#js-campaign-hashtag').text(),          
      loader_text : 'Cargando tweets', // loading text
      no_result : 'No se encontraron tweets recientes' // no results text
    });
  }
});

