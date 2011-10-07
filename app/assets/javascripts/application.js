//= require jquery
//= require jquery_ujs
//= require external
//= require campaigns


////////////////////////// goTo start
/*
 * Go to anchor tag with beauty effect
 * 
 * Usage:  goTo('que-ocurre-con-mis-datos-cuando-participo-en-una-campana-y-al-registrarme');
*/

function goTo(target){
    var targetOffset = $("#"+target).offset();
    var targetTop = targetOffset.top;
    $("html, body").animate({scrollTop:targetTop}, 1000);
}
////////////////////////// goTo end

////////////////////////// slugify start
/*
 * jQuery Slugify a string!
 * by Pablo Bandin
 * https://tracehello.wordpress.com/2011/06/15/jquery-real-slugify-plugin/
 * modified by Andres Pereira
 *
 * Usage:    alert( $.slugify("Crazy string with weird chars ñáéíóú ¨Ñ") );
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
jQuery.slugify = function( string ){
  var map = {"20":"-","24":"s","26":"8","30":"0","31":"1","32":"2","33":"3","34":"4","35":"5","36":"6","37":"7","38":"8","39":"9","41":"A","42":"B","43":"C","44":"D","45":"E","46":"F","47":"G","48":"H","49":"I","50":"P","51":"Q","52":"R","53":"S","54":"T","55":"U","56":"V","57":"W","58":"X","59":"Y","61":"a","62":"b","63":"c","64":"d","65":"e","66":"f","67":"g","68":"h","69":"i","70":"p","71":"q","72":"r","73":"s","74":"t","75":"u","76":"v","77":"w","78":"x","79":"y","100":"A","101":"a","102":"A","103":"a","104":"A","105":"a","106":"C","107":"c","108":"C","109":"c","110":"D","111":"d","112":"E","113":"e","114":"E","115":"e","116":"E","117":"e","118":"E","119":"e","120":"G","121":"g","122":"G","123":"g","124":"H","125":"h","126":"H","127":"h","128":"I","129":"i","130":"I","131":"i","132":"IJ","133":"ij","134":"J","135":"j","136":"K","137":"k","138":"k","139":"L","140":"l","141":"L","142":"l","143":"N","144":"n","145":"N","146":"n","147":"N","148":"n","149":"n","150":"O","151":"o","152":"OE","153":"oe","154":"R","155":"r","156":"R","157":"r","158":"R","159":"r","160":"S","161":"s","162":"T","163":"t","164":"T","165":"t","166":"T","167":"t","168":"U","169":"u","170":"U","171":"u","172":"U","173":"u","174":"W","175":"w","176":"Y","177":"y","178":"Y","179":"Z","180":"b","181":"B","182":"b","183":"b","184":"b","185":"b","186":"C","187":"C","188":"c","189":"D","190":"E","191":"F","192":"f","193":"G","194":"Y","195":"h","196":"i","197":"I","198":"K","199":"k","200":"A","201":"a","202":"A","203":"a","204":"E","205":"e","206":"E","207":"e","208":"I","209":"i","210":"R","211":"r","212":"R","213":"r","214":"U","215":"u","216":"U","217":"u","218":"S","219":"s","220":"n","221":"d","222":"8","223":"8","224":"Z","225":"z","226":"A","227":"a","228":"E","229":"e","230":"O","231":"o","232":"Y","233":"y","234":"l","235":"n","236":"t","237":"j","238":"db","239":"qp","240":"<","241":"?","242":"?","243":"B","244":"U","245":"A","246":"E","247":"e","248":"J","249":"j","250":"a","251":"a","252":"a","253":"b","254":"c","255":"e","256":"d","257":"d","258":"e","259":"e","260":"g","261":"g","262":"g","263":"Y","264":"x","265":"u","266":"h","267":"h","268":"i","269":"i","270":"w","271":"m","272":"n","273":"n","274":"N","275":"o","276":"oe","277":"m","278":"o","279":"r","280":"R","281":"R","282":"S","283":"f","284":"f","285":"f","286":"f","287":"t","288":"t","289":"u","290":"Z","291":"Z","292":"3","293":"3","294":"?","295":"?","296":"5","297":"C","298":"O","299":"B","363":"a","364":"e","365":"i","366":"o","367":"u","368":"c","369":"d","386":"A","388":"E","389":"H","390":"i","391":"A","392":"B","393":"r","394":"A","395":"E","396":"Z","397":"H","398":"O","399":"I","400":"E","401":"E","402":"T","403":"r","404":"E","405":"S","406":"I","407":"I","408":"J","409":"jb","410":"A","411":"B","412":"B","413":"r","414":"D","415":"E","416":"X","417":"3","418":"N","419":"N","420":"P","421":"C","422":"T","423":"y","424":"O","425":"X","426":"U","427":"h","428":"W","429":"W","430":"a","431":"6","432":"B","433":"r","434":"d","435":"e","436":"x","437":"3","438":"N","439":"N","440":"P","441":"C","442":"T","443":"Y","444":"qp","445":"x","446":"U","447":"h","448":"W","449":"W","450":"e","451":"e","452":"h","453":"r","454":"e","455":"s","456":"i","457":"i","458":"j","459":"jb","460":"W","461":"w","462":"Tb","463":"tb","464":"IC","465":"ic","466":"A","467":"a","468":"IA","469":"ia","470":"Y","471":"y","472":"O","473":"o","474":"V","475":"v","476":"V","477":"v","478":"Oy","479":"oy","480":"C","481":"c","490":"R","491":"r","492":"F","493":"f","494":"H","495":"h","496":"X","497":"x","498":"3","499":"3","500":"d","501":"d","502":"d","503":"d","504":"R","505":"R","506":"R","507":"R","508":"JT","509":"JT","510":"E","511":"e","512":"JT","513":"jt","514":"JX","515":"JX","531":"U","532":"D","533":"Q","534":"N","535":"T","536":"2","537":"F","538":"r","539":"p","540":"z","541":"2","542":"n","543":"x","544":"U","545":"B","546":"j","547":"t","548":"n","549":"C","550":"R","551":"8","552":"R","553":"O","554":"P","555":"O","556":"S","561":"w","562":"f","563":"q","564":"n","565":"t","566":"q","567":"t","568":"n","569":"p","570":"h","571":"a","572":"n","573":"a","574":"u","575":"j","576":"u","577":"2","578":"n","579":"2","580":"n","581":"g","582":"l","583":"uh","584":"p","585":"o","586":"S","587":"u","4a":"J","4b":"K","4c":"L","4d":"M","4e":"N","4f":"O","5a":"Z","6a":"j","6b":"k","6c":"l","6d":"m","6e":"n","6f":"o","7a":"z","a2":"c","a3":"f","a5":"Y","a7":"s","a9":"c","aa":"a","ae":"r","b2":"2","b3":"3","b5":"u","b6":"p","b9":"1","c0":"A","c1":"A","c2":"A","c3":"A","c4":"A","c5":"A","c6":"AE","c7":"C","c8":"E","c9":"E","ca":"E","cb":"E","cc":"I","cd":"I","ce":"I","cf":"I","d0":"D","d1":"N","d2":"O","d3":"O","d4":"O","d5":"O","d6":"O","d7":"X","d8":"O","d9":"U","da":"U","db":"U","dc":"U","dd":"Y","de":"p","df":"b","e0":"a","e1":"a","e2":"a","e3":"a","e4":"a","e5":"a","e6":"ae","e7":"c","e8":"e","e9":"e","ea":"e","eb":"e","ec":"i","ed":"i","ee":"i","ef":"i","f0":"o","f1":"n","f2":"o","f3":"o","f4":"o","f5":"o","f6":"o","f8":"o","f9":"u","fa":"u","fb":"u","fc":"u","fd":"y","ff":"y","10a":"C","10b":"c","10c":"C","10d":"c","10e":"D","10f":"d","11a":"E","11b":"e","11c":"G","11d":"g","11e":"G","11f":"g","12a":"I","12b":"i","12c":"I","12d":"i","12e":"I","12f":"i","13a":"l","13b":"L","13c":"l","13d":"L","13e":"l","13f":"L","14a":"n","14b":"n","14c":"O","14d":"o","14e":"O","14f":"o","15a":"S","15b":"s","15c":"S","15d":"s","15e":"S","15f":"s","16a":"U","16b":"u","16c":"U","16d":"u","16e":"U","16f":"u","17a":"z","17b":"Z","17c":"z","17d":"Z","17e":"z","17f":"f","18a":"D","18b":"d","18c":"d","18d":"q","18e":"E","18f":"e","19a":"l","19b":"h","19c":"w","19d":"N","19e":"n","19f":"O","1a0":"O","1a1":"o","1a2":"P","1a3":"P","1a4":"P","1a5":"p","1a6":"R","1a7":"S","1a8":"s","1a9":"E","1aa":"l","1ab":"t","1ac":"T","1ad":"t","1ae":"T","1af":"U","1b0":"u","1b1":"U","1b2":"U","1b3":"Y","1b4":"y","1b5":"Z","1b6":"z","1b7":"3","1b8":"3","1b9":"3","1ba":"3","1bb":"2","1bc":"5","1bd":"5","1be":"5","1bf":"p","1c4":"DZ","1c5":"Dz","1c6":"dz","1c7":"Lj","1c8":"Lj","1c9":"lj","1ca":"NJ","1cb":"Nj","1cc":"nj","1cd":"A","1ce":"a","1cf":"I","1d0":"i","1d1":"O","1d2":"o","1d3":"U","1d4":"u","1d5":"U","1d6":"u","1d7":"U","1d8":"u","1d9":"U","1da":"u","1db":"U","1dc":"u","1dd":"e","1de":"A","1df":"a","1e0":"A","1e1":"a","1e2":"AE","1e3":"ae","1e4":"G","1e5":"g","1e6":"G","1e7":"g","1e8":"K","1e9":"k","1ea":"Q","1eb":"q","1ec":"Q","1ed":"q","1ee":"3","1ef":"3","1f0":"J","1f1":"dz","1f2":"dZ","1f3":"DZ","1f4":"g","1f5":"G","1f6":"h","1f7":"p","1f8":"N","1f9":"n","1fa":"A","1fb":"a","1fc":"AE","1fd":"ae","1fe":"O","1ff":"o","20a":"I","20b":"i","20c":"O","20d":"o","20e":"O","20f":"o","21a":"T","21b":"t","21c":"3","21d":"3","21e":"H","21f":"h","22a":"O","22b":"o","22c":"O","22d":"o","22e":"O","22f":"o","23a":"A","23b":"C","23c":"c","23d":"L","23e":"T","23f":"s","24a":"Q","24b":"q","24c":"R","24d":"r","24e":"Y","24f":"y","25a":"e","25b":"3","25c":"3","25d":"3","25e":"3","25f":"j","26a":"i","26b":"I","26c":"I","26d":"I","26e":"h","26f":"w","27a":"R","27b":"r","27c":"R","27d":"R","27e":"r","27f":"r","28a":"u","28b":"v","28c":"A","28d":"M","28e":"Y","28f":"Y","29a":"B","29b":"G","29c":"H","29d":"j","29e":"K","29f":"L","2a0":"q","2a1":"?","2a2":"c","2a3":"dz","2a4":"d3","2a5":"dz","2a6":"ts","2a7":"tf","2a8":"tc","2a9":"fn","2aa":"ls","2ab":"lz","2ac":"ww","2ae":"u","2af":"u","2b0":"h","2b1":"h","2b2":"j","2b3":"r","2b4":"r","2b5":"r","2b6":"R","2b7":"W","2b8":"Y","2df":"x","2e0":"Y","2e1":"1","2e2":"s","2e3":"x","2e4":"c","36a":"h","36b":"m","36c":"r","36d":"t","36e":"v","36f":"x","37b":"c","37c":"c","37d":"c","38a":"I","38c":"O","38e":"Y","38f":"O","39a":"K","39b":"A","39c":"M","39d":"N","39e":"E","39f":"O","3a0":"TT","3a1":"P","3a3":"E","3a4":"T","3a5":"Y","3a6":"O","3a7":"X","3a8":"Y","3a9":"O","3aa":"I","3ab":"Y","3ac":"a","3ad":"e","3ae":"n","3af":"i","3b0":"v","3b1":"a","3b2":"b","3b3":"y","3b4":"d","3b5":"e","3b6":"c","3b7":"n","3b8":"0","3b9":"1","3ba":"k","3bb":"j","3bc":"u","3bd":"v","3be":"c","3bf":"o","3c0":"tt","3c1":"p","3c2":"s","3c3":"o","3c4":"t","3c5":"u","3c6":"q","3c7":"X","3c8":"Y","3c9":"w","3ca":"i","3cb":"u","3cc":"o","3cd":"u","3ce":"w","3d0":"b","3d1":"e","3d2":"Y","3d3":"Y","3d4":"Y","3d5":"O","3d6":"w","3d7":"x","3d8":"Q","3d9":"q","3da":"C","3db":"c","3dc":"F","3dd":"f","3de":"N","3df":"N","3e2":"W","3e3":"w","3e4":"q","3e5":"q","3e6":"h","3e7":"e","3e8":"S","3e9":"s","3ea":"X","3eb":"x","3ec":"6","3ed":"6","3ee":"t","3ef":"t","3f0":"x","3f1":"e","3f2":"c","3f3":"j","3f4":"O","3f5":"E","3f6":"E","3f7":"p","3f8":"p","3f9":"C","3fa":"M","3fb":"M","3fc":"p","3fd":"C","3fe":"C","3ff":"C","40a":"Hb","40b":"Th","40c":"K","40d":"N","40e":"Y","40f":"U","41a":"K","41b":"jI","41c":"M","41d":"H","41e":"O","41f":"TT","42a":"b","42b":"bI","42c":"b","42d":"E","42e":"IO","42f":"R","43a":"K","43b":"JI","43c":"M","43d":"H","43e":"O","43f":"N","44a":"b","44b":"bI","44c":"b","44d":"e","44e":"io","44f":"r","45a":"Hb","45b":"h","45c":"k","45d":"n","45e":"y","45f":"u","46a":"mY","46b":"my","46c":"Im","46d":"Im","46e":"3","46f":"3","47a":"O","47b":"o","47c":"W","47d":"w","47e":"W","47f":"W","48a":"H","48b":"H","48c":"B","48d":"b","48e":"P","48f":"p","49a":"K","49b":"k","49c":"K","49d":"k","49e":"K","49f":"k","4a0":"K","4a1":"k","4a2":"H","4a3":"h","4a4":"H","4a5":"h","4a6":"Ih","4a7":"ih","4a8":"O","4a9":"o","4aa":"C","4ab":"c","4ac":"T","4ad":"t","4ae":"Y","4af":"y","4b0":"Y","4b1":"y","4b2":"X","4b3":"x","4b4":"TI","4b5":"ti","4b6":"H","4b7":"h","4b8":"H","4b9":"h","4ba":"H","4bb":"h","4bc":"E","4bd":"e","4be":"E","4bf":"e","4c0":"I","4c1":"X","4c2":"x","4c3":"K","4c4":"k","4c5":"jt","4c6":"jt","4c7":"H","4c8":"h","4c9":"H","4ca":"h","4cb":"H","4cc":"h","4cd":"M","4ce":"m","4cf":"l","4d0":"A","4d1":"a","4d2":"A","4d3":"a","4d4":"AE","4d5":"ae","4d6":"E","4d7":"e","4d8":"e","4d9":"e","4da":"E","4db":"e","4dc":"X","4dd":"X","4de":"3","4df":"3","4e0":"3","4e1":"3","4e2":"N","4e3":"n","4e4":"N","4e5":"n","4e6":"O","4e7":"o","4e8":"O","4e9":"o","4ea":"O","4eb":"o","4ec":"E","4ed":"e","4ee":"Y","4ef":"y","4f0":"Y","4f1":"y","4f2":"Y","4f3":"y","4f4":"H","4f5":"h","4f6":"R","4f7":"r","4f8":"bI","4f9":"bi","4fa":"F","4fb":"f","4fc":"X","4fd":"x","4fe":"X","4ff":"x","50a":"H","50b":"h","50c":"G","50d":"g","50e":"T","50f":"t","51a":"Q","51b":"q","51c":"W","51d":"w","53a":"d","53b":"r","53c":"L","53d":"Iu","53e":"O","53f":"y","54a":"m","54b":"o","54c":"N","54d":"U","54e":"Y","54f":"S","56a":"d","56b":"h","56c":"l","56d":"lu","56e":"d","56f":"y","57a":"w","57b":"2","57c":"n","57d":"u","57e":"y","57f":"un"}
  var str = "";
    for(var i = 0; i<string.length; i++){
      str += map[ string.charCodeAt(i).toString(16) ] || "";
    }
    return str.toLowerCase();
}
////////////////////////// slugify end

////////////////////////// generateTOC start
function generateTOC(){
  $("#toc").prepend('<h2>Indíce</h2>');
  $("#page-info h3, #page-info h4").each(function(i) {
      var current = $(this);
      var current_slug = $.slugify(current.text());
      current.attr("id", current_slug);
      var html_line = "<a href='#" + current_slug + "' title='" + current.html() + "'>" + current.html() + "</a>";
      if (current.is('h3')) { 
        $("#toc").append("<br /><br />");
        $("#toc").append("<li><b>" + html_line + "</b></li>");
      } else {
        $("#toc").append("<li>" + html_line + "</li>");
      }
  }); 
  $("#toc a").click(function() {
    var fullUrl = this.href;
    var parts = fullUrl.split("#");
    var target = parts[1];
    goTo( target );
  }); 
}
////////////////////////// generateTOC end
    

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

////////////////////////// check-current-navbar start
function check_current_navbar(section){ 
  // TODO: mover al controlador, esto es una guarrada
  if ( section.split("#")[1] ) {
    var query = section.split("#")[1];
  }
  var section = section.split("#")[0];
  switch (section) {
    case "campaigns": 
      $("#header-campaigns").addClass("active");
      break;
    case "users":
      $("#header-signup").addClass("active");
      break;
    case "donate":
      $("#header-donate").addClass("active");
      break;
    case "help":
      $("#header-help").addClass("active");
      generateTOC();
      if (query) { goTo(query); }
      break;
  }
}
////////////////////////// check-current-navbar start

$(function() {

  $(".flash-messages").each(function() {
    msg = $(this).children("p");
    $.jGrowl(msg.text());
  });

  $("#user_email").focus();
  $("#campaign_name").focus();

  // activity-realtime
  //activity_init();

  check_current_navbar(document.URL.split('/')[3]);
  
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
  
  // edit-user clean password
  $("#user_edit #user_password").val("")

  var isInIFrame = (window.location != window.parent.location) ? true : false;
  if (isInIFrame) {
    $("#corner").hide();
    $("#navbar").hide();
    $("#links-wrapper").hide();
    $("#footer-wrapper").hide();
    $("#page").css("width", "inherit").addClass("grid_3");
    $("#page-info").css("width", "240px");
    $("#page-wrapper")
      .css("padding-bottom", "125px").css("padding-left", "1px");
    $("#page-wrapper #page #page-info").css("border-right", "none");
    $("#logo a img")
      .css("margin-bottom", "1em")
      .css("margin-left", "2em")
      .css("margin-top", "2em");
  }

  ///////////////////////// dialog2 - close modal windows with ESC key - start
  function __getOverlay(dialog) {
      return dialog.parent().prev(".modal-backdrop");
  }

  $(".modal").bind("keydown" ,function(event) {
    if (event.keyCode == "27") {
      var dialog = $(this).children(".modal-body");
      __getOverlay(dialog).hide();
      
      dialog
          .parent().hide().end()
          .trigger("dialog2.closed")
          .removeClass("opened");
    }
  });
  ///////////////////////// dialog2 - close modal windows with ESC key - end

});

$(window).load(function() {
  $("#slider").nivoSlider();
});

