$(function(){

  // para compartir en g+ al hacer click en el compartir de g+
  $('.js-social-button').on('click', function(e){
    e.preventDefault();
    var share_url = $(this).attr('href');
    var myWindow = window.open(share_url, 'sharer', 'toolbar=0,status=0,width=626,height=436');
  });

});
