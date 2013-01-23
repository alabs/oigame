
//$.noConflict();

jQuery.fn.directText = function(settings) {
   settings = jQuery.extend({},jQuery.fn.directText.defaults, settings);
   return this.contents().map(function() {
     if (this.nodeType != 3) return undefined; // remove non-text nodes
     var value = this.nodeValue;
     if (settings.trim) value = jQuery.trim(value);
     if (!value.length) return undefined; // remove zero-length text nodes
     return value;
   }).get().join(settings.joinText);
};

jQuery.fn.directText.defaults = {
   trim: true,
   joinText: ''
};

jQuery('.search_translate').click(function(e) {
  e.preventDefault();
  var that = jQuery(this);
  var phrase = that.parent().parent().children('.phrase').directText();
  that.html('<img src="/assets/ajax-loader.gif">');
  var lang = jQuery("#js-lang").data('locale');
  jQuery.getJSON('http://mymemory.translated.net/api/get?q=' + phrase + '!&langpair=es|' + lang, function(data){
    that.html('Buscar');
    that.parent().parent().children('.translation').children('textarea').val(data.responseData.translatedText);
  });
});

