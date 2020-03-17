var express = require('express');
var app = express();

var port = process.env.PORT || 17022;
var mysql = require('mysql');
var path = require('path');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
//var bodyParserBson = require('body-parser-bson');
var cors = require('cors');

app.use(cors({origin: true}));
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
//app.use(bodyParserBson.bson());

/***************Mysql configuratrion********************/
var configDB = require('./config/database.js');
// connect to our database
var pool = mysql.createPool(
    {
        connectionLimit: configDB.connectionlimit,
        host     : configDB.host,
        user     : configDB.user,
        password : configDB.password,
        database : configDB.database,
        multipleStatements: true
    });

app.use(cookieParser('ws2017gsdhsfulda'));
 
//view engine setup

// for local server
//app.set('views', path.join(__dirname, 'app/views'));
//app.use('*/img',express.static('public/img'));
//app.use('*/css',express.static('public/css'));
//app.use('*/font',express.static('public/font'));
//app.use('*/js',express.static('public/js'));
//app.use('*/sass',express.static('public/sass'));
//app.use('*/',express.static('public'));

// for heroku cloud server
app.set('views', path.join(process.env.PWD, 'Milestones/Milestone3/biig/app/views'));
app.use('*/img',express.static('Milestones/Milestone3/biig/public/img'));
app.use('*/css',express.static('Milestones/Milestone3/biig/public/css'));
app.use('*/font',express.static('Milestones/Milestone3/biig/public/font'));
app.use('*/js',express.static('Milestones/Milestone3/biig/public/js'));
app.use('*/sass',express.static('Milestones/Milestone3/biig/public/sass'));
//app.use('',express.static('public'));
app.set('view engine', 'ejs');

////////////////////////////////////////

// routes
require('./config/routes.js')(app, pool);

//launch
app.listen(port);
console.log('The magic happens on port ' + port);
