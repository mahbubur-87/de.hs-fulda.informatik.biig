var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');

var app = new express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.set('view engine', 'ejs');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'fa17g22',
  password : 'group22!',
  database: 'fa17g22'
});

connection.connect(function(err) {
  if (err) {
    console.error('error connecting: ' + err.stack);
    return;
  }
  console.log('connected as id ' + connection.threadId);
});

connection.query("select * from Customers", function (error, results, fields) {
  if (error) throw error;
  else {
    console.log(results);
  }
});

app.get('/',function(req,res,next)
{
  res.render('try1');
});

app.get('/fa17g22',function(req,res,next)
{
  res.render('try1');
});

app.post('/fa17g22/save', function(req, res)
{
  console.log('req.body: ');
  console.log(req.body);

  connection.query("Insert into Customers (username,email,firstName,lastName,dateOfBirth,password,securityAnswer) VALUES ('"+req.body.email+"','"+req.body.email+"','"+req.body.fName+"','"+req.body.lName+"','"+req.body.dob+"','"+req.body.password+"','123')",function(err, result)
  {
    var msg = err ? "\'Error inserting to database\'" : "\'Inserted to database\'";
    res.render('try1', {msg: msg});

  });
});

app.get('/fa17g22/getcustomers', function(req, res)
{
  console.log('req.body: ');
  console.log(req.body);

  connection.query("select customer_id, username, firstName, lastName, email, DATE_FORMAT(dateOfBirth, '%M %d %Y') as dob from Customers", function(err, results, fields)
  {
    if(err)
    {
      res.render('try1', {msg: "\'Error reading from database.\'"});
      console.log("Error reading from database: "+err);
    }
    else {
      res.render('allCustomers', {page_title:"Test Table",data:results});
      console.log(results);
    }
  });
});

app.listen(17022);

console.log('Example app listening at port:17022');
