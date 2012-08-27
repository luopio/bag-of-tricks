const fbId = "393468444053934";
const fbSecret = "ab85f750ab09afb91ac76303b2e81294";
const fbCallbackAddress= "http://localhost:1302/auth/facebook_callback";

var connect = require('connect')
    ,auth = require('connect-auth')
    ,url = require('url')
    ,fs = require('fs');

process.on('uncaughtException', function (err) {
    console.log('Caught exception: ' + err.stack);
});


var unAuthenticatedContent =
'<html> \
    <head> \
    <title>Connect Auth -- Not Authenticated</title> \
    <style type="text/css"> \
    .section { \
        float:left; \
        } \
    </style> \
    <script src="http://static.ak.fbcdn.net/connect/en_US/core.js"></script> \
</head> \
<body> \
    <table> \
        <tr> \
        <th class="first">Name</th> \
        <th>Try it!</th> \
        </tr> \
        <tr class="row-a"> \
        <td class="first">Facebook</td> \
        <td><div class="fb_button" id="fb-login" style="float:left; background-position: left -188px"> \
        <a href="http://localhost:1302/login" class="fb_button_medium"> \
            <span id="fb_login_text" class="fb_button_text"> \
            Connect with Facebook \
            </span> \
        </a> \
        </div> \
        </td> \
    </table> \
</body> \
</html>';

var authenticatedContent =
'<html> \
    <head> \
    <title>Connect Auth -- Authenticated</title> \
    </head> \
<body> \
    <div id="wrapper"> \
        <h1>Authenticated</h1> \
        <div id="user">#USER#</div> \
        <h2><a href="/logout">Logout</a></h2> \
    </div> \
</body> \
</html>';

var app = connect();
app.use(connect.cookieParser('my secret herez'))
    .use(connect.session())
    .use(connect.bodyParser())

    .use(auth({
        strategies:
            [auth.Anonymous()
            ,auth.Never()
            ,auth.Facebook({appId : fbId, appSecret: fbSecret, scope: "email", callback: fbCallbackAddress})
        ],
        trace: true
        // logoutHandler: require('connect-auth').redirectOnLogout("/")
        }))

    .use("/login",
        function(req, res, next) {
            var urlp = url.parse(req.originalUrl, true)
            req.authenticate(["facebook"],
                function(error, authenticated) {
                    if( error ) {
                        // Something has gone awry, behave as you wish.
                        console.log( error );
                        res.end();
                    } else {
                        if( authenticated === undefined ) {
                            // The authentication strategy requires some more browser interaction, suggest you do nothing here!
                        } else {
                            // We've either failed to authenticate, or succeeded (req.isAuthenticated() will confirm, as will the value of the received argument)
                            next();
                        }
                    }
                }
            );
        }
    )

    .use('/logout', function(req, res, params) {
        req.logout(); // Using the 'event' model to do a redirect on logout.
    })

    .use("/", function(req, res, params) {
        console.log('=== use/')
        res.writeHead(200, {'Content-Type': 'text/html'})
        if( req.isAuthenticated() ) {
            console.log('iz authenticated: ' + JSON.stringify( req.getAuthDetails()));
            var userId = req.getAuthDetails().user.id;
            db.setPlayerData(id, req.getAuthDetails().user);
            res.end( authenticatedContent.replace("#USER#", JSON.stringify( req.getAuthDetails().user )  ) );
        }
        else {
            res.end( unAuthenticatedContent.replace("#PAGE#", req.originalUrl) );
        }
    })

    .listen(1302);