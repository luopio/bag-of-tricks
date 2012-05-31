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
  } else if(e.keyCode == 13) {
      // do something with enter
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


//=========================================================//
// Get tweets from user
function getTweetsFromUser(userName, callback) {
    $.getJSON('http://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&screen_name=' + userName + '&count=10&callback=?')
        .success(
        function(data) {
            console.dir(data);
            if(callback)
                callback(data);
        }
    )
        .error(
        function(data) {
            alert('failed to retrieve twiits for '+userName);
        }
    );
}
//=========================================================//


//=========================================================//
// Flash detection with swfobject
if(swfobject.hasFlashPlayerVersion("1")) {
    alert("You have flash!");
} else {
    alert("You do not flash :-(");
}
//=========================================================//


//=========================================================//
// Custom validation for jquery.validate
// this one requires the text "buga", we define a default message, too
$.validator.addMethod("buga", function(value) {
    return value == "buga";
}, 'Please enter "buga"!');

// this one requires the value to be the same as the first parameter
$.validator.methods.equal = function(value, element, param) {
    return value == param;
};
// usage
/*
[..].validate({
    [...]
        rules: {
            number: {
                required:true,
                minlength:3,
                maxlength:15,
                number:true
            },
            secret: "buga",
            math: {
                equal: 11
            }
        }
    });
*/