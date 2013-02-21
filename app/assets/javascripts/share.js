$(function(){

  // para compartir en facebook al hacer click en el compartir de FB
  $('.js-fb-share').on('click', function(e){
    e.preventDefault();
    var t=encodeURIComponent($("meta[property='og:title']").attr('content'));
    var d=encodeURIComponent($("meta[property='og:description']").attr('content'));
    var u=encodeURIComponent($("meta[property='og:url']").attr('content'));
    var i=encodeURIComponent($("meta[property='og:image']").attr('content'));
    var share_url='http://www.facebook.com/sharer.php';
    share_url+='?s=100&p[title]='+t+'&p[summary]='+d+'&p[url]='+u;
    share_url+='&p[images][0]='+i;
    share_url+='&t='+t+'&e='+d;
    var myWindow = window.open(share_url, 'sharer', 'toolbar=0,status=0,width=626,height=436');
  });

  // para compartir en g+ al hacer click en el compartir de g+
  $('.js-google-plus-share').on('click', function(e){
    e.preventDefault();
    var share_url = $(this).attr('href');
    var myWindow = window.open(share_url, 'sharer', 'toolbar=0,status=0,width=626,height=436');
  });

});
