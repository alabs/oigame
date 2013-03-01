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

$( function(){ 
 
  // mensaje modal de beta para cuando se entra al entorno staging por primera vez
//  var environment = $("meta[name=generator]").attr("content").split(" - ")[1];
//  if ( environment == "staging" ) { 
//    if ( readCookie('beta-welcome') == null ) {
//      $("#modal-beta-notice").dialog2({
//        removeOnClose: false,
//        autoOpen: true
//      });
//      $("#modal-beta-notice").parent().addClass("modal-large");
//      createCookie('beta-welcome', 'visited', 100); 
//    }
//  }
  
});
