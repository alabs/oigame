// PARA LA HOME

// http://www.simonwhatley.co.uk/parsing-twitter-usernames-hashtags-and-urls-with-javascript

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


$(function () {
  $.ajax({
    dataType: "jsonp",
    url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=oigame",
    success: function (twits) {
      var html = '';
      for (i = 0; i < twits.length; i++) {
        html += '<li>' + twits[i].text + '</li>';
      }
      $('#twitter').html(html.parseURL().twParseUsername().twParseHashtag());
      $('#twitter>li').carrusel();
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

