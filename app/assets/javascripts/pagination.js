$(function(){
  $('.campaign-infolist .previous_page').hide()

  $('.thumbnails').isotope({
    // options
    itemSelector : '.item',
    layoutMode   : 'fitRows'
  });


$('.campaign-infolist .next_page')
  .addClass('btn_readmore')
  .click(function(e){

    var btn = $(this);
    btn.addClass('disabled');
    var page = btn.attr('href').split('?')[1].split('=')[1];

    e.preventDefault();
    $.ajax({
      url: document.location.pathname + '?page=' + page,
      type: 'get',
      dataType: 'script',
      success: function(data) {
        $('.thumbnails').isotope( 'reloadItems' ).isotope(); 
        btn.removeClass('disabled');
        page++;
        btn.attr('href', next_link = btn.attr('href').split('=')[0] + '=' + page);
        if (data.trim() == "$('.thumbnails').append('');") {
          $('.alert-pagination-end').show().slideDown('slow');
          btn.hide();
        }
      }
    });

  })
});
