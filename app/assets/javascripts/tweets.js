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
