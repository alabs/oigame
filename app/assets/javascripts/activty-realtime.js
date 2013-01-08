$(function(){
  if ( $('#realtime').length > 0) activityStream({ itemCount: 7, listSelector: "#realtime ul", streamUrl: "/es/activity.json" }); 
});

function activityStream(e) {
    function l(e) {
        var n, r;
        if (!e) return;
        n = $("<span style='font-size: 0.8em; float: right;' class='timestamp'>" + distanceOfTimeInWords(e.timestamp) + "</span>");
        n.data("actualDate", e.timestamp);
        html = "<li><img style='width: 50px; float: left;' src='" + e.camp_img +"'>";
        html += "<a href='" + e.camp_url + "'>";
        html += "<label>" + e.part_name + " ha participado en " + e.camp_name + "</label></a>";
        r = $(html);
        r.append(n);
        r.hide();
        o.prepend(r);
        r.show(s);
        var i = r.find(".activity");
        i.width() > 300 && (i.width(300), r.append('<div class="ellipsis">...</div>'))
    }
    function c() {
        for (var e = 0; e < r; e++) l(a.pop());
        u = !0, setTimeout(v, i)
    }l
    function h() {
        var e = o.find("li:last");
        e.hide(s, function () {
            e.remove()
        })
    }
    function p() {
        o.find(".timestamp").each(function (e, t) {
            var n = $(t),
                r = n.data("actualDate");
            n.text(distanceOfTimeInWords(r))
        })
    }
    function d() {
        setTimeout(g, t)
    }
    function v() {
        p(), l(a.pop()), h(), a.length === 0 ? g() : setTimeout(v, i)
    }
    function m(e, t, n) {
        $.each(e, function (e, t) {
            $.inArray(t.id, f) === -1 && (f.push(t.id), a.push(t))
        }), u ? a.length === 0 ? (p(), d()) : v() : c()
    }
    function g() {
        $.getJSON(n, m)
    }
    var t = 15e3,
        n = e.streamUrl,
        r = e.itemCount || 3,
        i = e.delayBetweenItems || 4e3,
        s = e.effect || "blind",
        o = $(e.listSelector),
        u = !1,
        a = [],
        f = [];
    g()
}

function distanceOfTimeInWords(epoch) {
    var r = Math.round((new Date).getTime() / 1000 - parseInt(epoch));
    if (r < 60) return "hace " + r + " segundos";
    if (r < 120) return "hace 1 minuto";
    if (r < 2700) return "hace " + parseInt(r / 60).toString() + " minutos";
    if (r < 7200) return "an hour ago";
    if (r < 86400) return "hace " + parseInt(r / 3600).toString() + " horas";
    if (r < 172800) return "hace 1 día";
    var i = parseInt(r / 86400).toString();
    return "hace " + i + " días"
}
