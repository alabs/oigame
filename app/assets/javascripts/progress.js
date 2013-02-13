
// based on http://jsfiddle.net/526hM/ 
// based on http://stackoverflow.com/questions/11998913/animate-html5-progress-bar-with-javascript



$(document).ready(function(){
    $('progress').each( function(){
        var interval = 2, //How much to increase the progressbar per frame
        updatesPerSecond = 1000/60, //Set the nr of updates per second (fps)
        progress =  $(this),
        animator = function(){
            progress.val(progress.val()+interval);
            if ( progress.val()+interval < progress.attr('value')){
               setTimeout(animator, updatesPerSecond);
            } else { 
                progress.val(progress.attr('value'));
            }
        }
    
        setTimeout(animator, updatesPerSecond);
    });
});
