// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
//
////////////////////////// cookies start

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}
////////////////////////// cookies end

////////////////////////// activity-realtime start

// activity-realtime: como el What's happening now de getup.org.au, 
// muestra 10 elementos y va quitando uno de abajo y poniendo otro arriba

// TODO: request por ajax y continuar procesando hasta el final
// TODO: CSS bonito

var data = [
  {"id":33908182,"html":"<span class=\"name\">Wendy</span> signed to <a href=\"/campaigns/coal-seam-gas/csg-ad-petition/dont-risk-coal-seam-gas\">stop coal seam gas mining</a>.","timestamp":"Mon, 19 Sep 2011 14:30:55 GMT"},
  {"id":33908157,"html":"<span class=\"name\">Yvonne</span> asked the NSW Govt <a href=\"/campaigns/coal-seam-gas/hunter-valley/sign-the-petition\">to protect the Hunter Valley</a>.","timestamp":"Mon, 19 Sep 2011 14:23:21 GMT"},
  {"id":33908154,"html":"<span class=\"name\">Eric</span> signed to <a href=\"/campaigns/coal-seam-gas/add-your-voice/chip-in\">stop coal seam gas mining</a>.","timestamp":"Mon, 19 Sep 2011 14:22:54 GMT"},
  {"id":33908152,"html":"<span class=\"name\">John</span> signed to <a href=\"/campaigns/coal-seam-gas/add-your-voice/chip-in\">stop coal seam gas mining</a>.","timestamp":"Mon, 19 Sep 2011 14:22:34 GMT"},
  {"id":33908136,"html":"<span class=\"name\">Brendan</span> signed to <a href=\"/campaigns/coal-seam-gas/add-your-voice/chip-in\">stop coal seam gas mining</a>.","timestamp":"Mon, 19 Sep 2011 14:18:48 GMT"},
  {"id":33908077,"html":"<span class=\"name\">Paul</span> signed to <a href=\"/campaigns/coal-seam-gas/add-your-voice/chip-in\">stop coal seam gas mining</a>.","timestamp":"Mon, 19 Sep 2011 14:05:25 GMT"},
  {"id":33908053,"html":"<span class=\"name\">Nicholas</span> just joined GetUp!","timestamp":"Mon, 19 Sep 2011 14:01:55 GMT"},
  {"id":33908050,"html":"<span class=\"name\">Bernard</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:40 GMT"},
  {"id":33908049,"html":"<span class=\"name\">Susannah</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:35 GMT"},
  {"id":33908048,"html":"<span class=\"name\">Nicholas</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:31 GMT"},
  {"id":33908047,"html":"<span class=\"name\">Christine</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:28 GMT"},
  {"id":33908046,"html":"<span class=\"name\">Peter</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:25 GMT"},
  {"id":33908044,"html":"<span class=\"name\">Deborah</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:21 GMT"},
  {"id":33908042,"html":"<span class=\"name\">Brian</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:18 GMT"},
  {"id":33908040,"html":"<span class=\"name\">John</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:14 GMT"},
  {"id":33908039,"html":"<span class=\"name\">Michelle</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:10 GMT"},
  {"id":33908038,"html":"<span class=\"name\">Attracta</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:06 GMT"},
  {"id":33908037,"html":"<span class=\"name\">Andre</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:03 GMT"},
  {"id":33908036,"html":"<span class=\"name\">Judith</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:01:00 GMT"},
  {"id":33908034,"html":"<span class=\"name\">Patrick</span> donated to <a href=\"/campaigns/support/fund-hope-not-hate/fund-hope-not-hate\">fund hope not hate</a>.","timestamp":"Mon, 19 Sep 2011 14:00:56 GMT"}
];


function activity_init(){
  $.each(data, function(i, item) {
    // mostrar 10 elementos
    if (i < 5){
      activity_load(data[i].html);
    } else {
      // esto es por el puto sleep en el javascript, hay que estar haciendo movidas por los milisegundos
      // y para que no sea el mismo para todos :S
      var t = 2000 * i - 20000;
      setTimeout(function() { 
        activity_clean(); 
        activity_load_pretty(data[i].html);
      },t);
    }
  });
}

function activity_load(html){
  // agregar 1 -- iniciales
  $("#activity-realtime ul").prepend("<li>" + html + "</li>");
}

function activity_load_pretty(html){
  // agregar 1 -- con efecto de fadeIn
  $("#activity-realtime ul").prepend($("<li>" + html + "</li>").fadeIn('slow'));
}

function activity_clean(){
  // comprueba la actividad visible y si son mas que n va quitando los n+1
  var $activity_visible = $('#activity-realtime ul li:visible');
  if ($activity_visible.length > 7) { 
    $.each($activity_visible, function(i, item) {
      if ( i > 8 ){
        $(this).slideDown(400).delay(800).fadeOut(400);  
      } 
    });
  }
}

////////////////////////// activity-realtime end
//
////////////////////////// check-current-navbar start

function check_current_navbar(section){ 
  // TODO: mover al controlador, esto es una guarrada
  switch (section) {
    case 'campaigns': 
      $('#header-campaigns').addClass('active');
      break;
    case 'users':
      $('#header-signup').addClass('active');
      break;
  }
}
////////////////////////// check-current-navbar start

$(function() {

  $("#slider").nivoSlider();

  $(".flash-messages").delay(15000).fadeOut();

  $(".flash-messages a.close").click(function() {
    $(".flash-messages").toggle();
  });

  $("#user_email").focus();
  $("#campaign_name").focus();

  // activity-realtime
  //activity_init();

  check_current_navbar(document.URL.split('/')[3]);

  // Al hacer click en unirse a una campaña, hacer el scroll
  // y poner foco en el campo nombre
  $("#join-this-campaign-link").click(function(event) {
    event.preventDefault();
    var fullUrl = this.href;
    var parts = fullUrl.split("#");
    var target = parts[1];
    var targetOffset = $("#"+target).offset();
    var targetTop = targetOffset.top;
    $("html, body").animate({scrollTop:targetTop}, 1000);
    $("#campaign-message-form #email").focus();
  }); 

  // modal-stats start
  $("#modal-stats-window").dialog2({
    removeOnClose: false,
    autoOpen: false
  });

  $("#show-modal-stats-window").click(function(event) {
    event.preventDefault();
    $("#modal-stats-window").dialog2("open");
  });
  // modal-stats end

  // modal-widget start
  $("#modal-widget-window").dialog2({
    removeOnClose: false,
    autoOpen: false
  });

  $("#show-modal-widget").click(function(event) {
    $("#modal-widget-window").parent().addClass("modal-large");
    event.preventDefault();
    $("#modal-widget-window").dialog2("open");
  });
  // modal-widget end

  // comment-form floating start
  $('#show-campaign-sidebar').scrollToFixed({
    marginTop:
      $('#header').outerHeight() + 10,
    limit:
      $('#links-wrapper').offset().top - $('#show-campaign-sidebar').outerHeight() - 10
  });
  // comment-form floating end
  
  
  // modal-beta-home start
  if ( readCookie('beta-welcome') == null ) {
    $("#modal-beta-notice").dialog2({
      removeOnClose: false,
      autoOpen: true
    });
    $("#modal-beta-notice").parent().addClass("modal-large");
    createCookie('beta-welcome', 'visited', 100); 
  }
  // modal-beta-home end
  

});
