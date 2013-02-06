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
function trackEvent(category, action, opt_label) {
    try { _gaq.push(['_trackEvent', category, action, opt_label]);} 
    catch(err) {;}
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
// Jquery.Validate plugin example code

    var validator = $('#register').validate({
        rules: {
            name: {
                required: true,
                minlength: 2 },
            email: { required: true, email: true },
            firstpass: {
                required: true,
                minlength: 2 },
            pass_confirm: {
                required: true,
                minlength: 2,
                equalTo: '#firstpass[type="password"]' },
            step_1: { required: true},
            step_2: { required: true},
            perms1: { required: true},
            perms2: { required: false}
        },
        // onkeyup: false,
        messages: {
            name: {required: "Ole hyvä ja syötä nimesi", minlength: "Nimen pitää olla yli 2 merkkiä."},
            email: "Sähköposti puuttuu tai on virheellinen",
            firstpass: {
                required: "Salasana puuttuu",
                minlength: "Salasanan täytyy olla yli 2 merkkiä pitkä."
            },
            pass_confirm: {
                required: "Salasana puuttuu",
                minlength: "Salasanan täytyy olla yli 2 merkkiä pitkä.",
                equalTo: "Salasanat eivät täsmää!"
            },
            perms1: "Käyttöehdot täytyy hyväksyä"
        },
        //errorPlacement: function(error, element) {
        //    element.after( error );
        //}
    });

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
//=========================================================//
// Fisher-Yates array randomization
//=========================================================//
function fisherYates ( myArray ) {
    var i = myArray.length;
    if ( i == 0 ) return false;
    while ( --i ) {
        var j = Math.floor( Math.random() * ( i + 1 ) );
        var tempi = myArray[i];
        var tempj = myArray[j];
        myArray[i] = tempj;
        myArray[j] = tempi;
    }
}


//=========================================================//
// Mobile detection via browser agent
//=========================================================//
// support for overriding detection
var q=window.location.search.substring(1);
(function(a)
{
  if((q.indexOf("mobile")===-1)
      // detect mobile clients
      && (!(/android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|xoom|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))))
      // detect csstransform features
      && (Modernizr.csstransforms && Modernizr.mq("only screen and (min-width: 700px)"))
      // detect iOS version (don't pass 1-4)
      && !(/OS [1-4]_\d(_\d)? like Mac OS X/i.test(navigator.userAgent))
      )
  {
    window.location="launch/";
  }
})((navigator.userAgent||navigator.vendor||window.opera));




//=========================================================//
// requestAnimationFrame polyfill (http://paulirish.com/2011/requestanimationframe-for-smart-animating/)
//=========================================================//
// shim layer with setTimeout fallback
window.requestAnimFrame = (function(){
  return  window.requestAnimationFrame       || 
          window.webkitRequestAnimationFrame || 
          window.mozRequestAnimationFrame    || 
          window.oRequestAnimationFrame      || 
          window.msRequestAnimationFrame     || 
          function( callback ){
            window.setTimeout(callback, 1000 / 60);
          };
})();
// usage: 
// instead of setInterval(render, 16) ....
(function animloop(){
  requestAnimFrame(animloop);
  render();
})();
// place the rAF *before* the render() to assure as close to 
// 60fps with the setTimeout fallback.
