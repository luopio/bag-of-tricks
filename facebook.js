
/* ========================================================== */
/* Animated scroll to                                         */
/* ========================================================== */
function FBScrollTo(y){
    FB.Canvas.getPageInfo(function(pageInfo){
        $({y: pageInfo.scrollTop}).animate(
            {y: y},
            {duration: 1000, step: function(offset){
                FB.Canvas.scrollTo(0, offset);
            }
            });
    });
}


/* ========================================================== */
/* Facebook setAutoGrow fix for IE and dynamic layouts.
   You need to call $(window).resize() manually whenever
   you know the size has changed or put it in an interval.
   Also you need something like

 <!--[if lte IE 8]> <html class="no-js ie oldie" lang="en"> <![endif]-->
 <!--[if gt IE 8]> <html class="no-js" lang="en"> <!--<![endif]-->

   in the beginning of your page to place the .ie class to HTML tag

 */
/* ========================================================== */
if($('html').hasClass('ie')) {
    $(window).resize(function() {
        FB.Canvas.setSize({ width: 810, height: $('body').height() });
    });
} else {
    FB.Canvas.setAutoGrow();
}


/* ========================================================== */
/* Listen for likes on the given url. Redirect when something
   happens. */
/* ========================================================== */
FB.Event.subscribe('edge.create', function(response) {
    if (response && response == "FBPageUrlHere") {
        top.location.href = "RedirectToUrl";
    }
});
