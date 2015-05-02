/**
 * Created by allan on 5/2/15.
 */

var express = require('express');
var app = express();

//app.get('/*', function(req, res, next){
//    res.setHeader('Last-Modified', (new Date()).toUTCString());
//    next();
//});

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/src/html/main.html');
});

app.use('/vendor', express.static('bower_components'));
app.use('/js', express.static('dest/js'));
app.use('/css', express.static('dest/css'));
app.use('/images', express.static('src/images'));

var server = app.listen(3000, function () {

    var host = server.address().address;
    var port = server.address().port;

    if (host == '::') host = 'localhost';

    console.log('WayThere app listening at http://%s:%s', host, port);

});