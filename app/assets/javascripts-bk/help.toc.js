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

////////////////////////// generateTOC start
function generateTOC(section){
  $(section + " #toc").prepend('<h2>Indíce</h2>');
  $(section + " #page-info h3, " + section + " #page-info h4").each(function(i) {
      var current = $(this);
      var current_slug = $.slugify(current.text());
      current.attr("id", current_slug);
      var html_line = "<a href='#" + current_slug + "' title='" + current.html() + "'>" + current.html() + "</a>";
      if (current.is('h3')) { 
        $(section + " #toc").append("<br /><br />");
        $(section + " #toc").append("<li><b>" + html_line + "</b></li>");
      } else {
        $(section + " #toc").append("<li>" + html_line + "</li>");
      }
  }); 
  $(section + " #toc a").click(function() {
    var fullUrl = this.href;
    var parts = fullUrl.split("#");
    var target = parts[1];
    goTo( target );
  }); 
}
////////////////////////// generateTOC end
