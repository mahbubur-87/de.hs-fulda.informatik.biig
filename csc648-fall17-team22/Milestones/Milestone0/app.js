var express = require('express');
var parser = require('body-parser');
var path = require('path');
var app = express();

// Setting ejs view engine to render ejs pages
app.set('view engine', 'ejs');

// Setting relative paths for static resources
app.use('*/img',express.static('public/images'));
app.use('*/scripts',express.static('public/scripts'));

// Creating a server and listening to the designated port
var server = app.listen(17022, "localhost", function()
{
  var host = server.address().address;
  var port = server.address().port;
  console.log("Host: "+host+" Port: "+port);
});

// Parser to help parse form POST data
var urlencodedParser = parser.urlencoded({ extended: false })

// Entry point for localhost on local developer machines
app.get('/', function(req,res)
{
  res.render('index');
});

// Entry point for application on the web url
app.get('/fa17g22', function(req,res)
{
  res.render('index');
});

// Routing to individual profile pages
app.get('/fa17g22/aleksandar', function(req,res)
{
  res.render('./Aleks/Aleks-Profile');
});

app.get('/fa17g22/swetaketu', function(req,res)
{
  res.render('./Swetaketu/index');
});

app.get('/fa17g22/akhila', function(req,res)
{
  res.render('./Akhila/Akhila_Profile');
});

app.get('/fa17g22/mahbubur', function(req,res)
{
  res.render('./Mahbubur/mahbub');
});

app.get('/fa17g22/mahdis', function(req,res)
{
  res.render('./Mahdis/cv2');
});

app.get('/fa17g22/rohan', function(req,res)
{
  res.render('./Rohan/myinfo');
});
