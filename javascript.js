//=========================================================//
// Proper way to preventdefault (second line for IE):
if(e && e.preventDefault) { e.preventDefault(); }
else { e.returnValue = false; }
//=========================================================//


//=========================================================//
// Catch keypresses and discard presses with modifiers:
$(document).keydown(function(e) {
  if(e.ctrlKey || e.shiftKey || e.altKey || e.metaKey) { return; }

  if(e.keyCode == 37) {
    // do something with left arrow
  } else if(e.keyCode == 38) {
    // do something with up arrow
  } else if(e.keyCode == 40) {
    // do something with down arrow
  } else if(e.keyCode == 39) {
    // do something with right arrow
  } else if(e.keyCode == 27) {
    // do something with esc
  }
});
//=========================================================//


//=========================================================//
// Jquery-based scrollTo:
$(document).ready( function () {
    $('.scroll').click(function() {
        var target = $(this).attr("href");
        var destination = $(target).offset().top;
        $("html:not(:animated),body:not(:animated)").animate({ scrollTop: destination-20}, 800 );
        return false;
    });
});
//=========================================================//


//=========================================================//
// Extract a GET parameter via JS 
function getURLParameter(name) {
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}
//=========================================================//


//=========================================================//
// Track links with GA 
var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'XXXXX']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  function trackLink(linkElement) {
    try {
      _gaq.push(['_trackEvent', 'Outbound Links', 'External', $(linkElement).attr('href')]);
      setTimeout(function() { window.open($(linkElement).attr('href')); }, 100)
    } catch(err) {;}
  }
//=========================================================//
