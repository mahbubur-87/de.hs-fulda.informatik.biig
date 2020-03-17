/*
File Name: modelCustomer.js

Description:
This is a customer model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Swetaketu Majumder
*/

var mUser = require('../models/modelUser');

module.exports = {
    addCustomer: addCustomer,
    findById: findById,
    findUserId: findUserId,
    editCustomer: editCustomer,
    editDP: editDP
};

var custBaseSql2 = "select c.id as customerid, c.*, u.*, addr.* from customer c left join `user` u on c.`user` = u.id left join address addr on c.address = addr.id ";

function findUserId(callback,connection,id)
{
  process.nextTick(function()
  {
    var usersql="select u.id from user u, customer c where c.user = u.id and c.id = "+id;
    connection.query(usersql, function (err, results)
    {
        if (err)
        {
            console.log(err);
            return callback(err);
        }
        console.log("\n\nSUCCESS: "+JSON.stringify(results[0])+"\n\n");
        callback(null, results[0]);
    });
  });
}


function findById (callback, connection, id)
{
    process.nextTick (function ()
    {
        console.log("\n\nINSIDE CUSTOMER FIND BY ID: "+id+"\n\n");
        var custSql = custBaseSql2 + " where c.id = " + id;
        console.log(custSql);
        connection.query(custSql, function (err, results)
        {
            if (err)
            {
                console.log(err);
                return callback(err);
            }
            console.log("\n\nSUCCESS: "+JSON.stringify(results[0])+"\n\n");
            callback(null, results[0]);
        });
    });
}


function findByUserId (callback, connection, userId)
{
    process.nextTick (function ()
    {
        var custSql = custBaseSql + " AND cust.`user` = " + userId;

        connection.query(custSql, function (err, results)
        {
            if (err)
            {
                console.log(err);
                return callback(err);
            }
            callback(null, results[0]);
        });
    });
}

function addCustomer (callback, connection, customer)
{
    process.nextTick(function ()
    {
        mUser.findByEmail(connection, customer.email, function(err, user)
        {
            if(err)
            {

            }
            else if(user)
            {
                callback(null, null, "An account already exists with the same email.");
            }
            else
            {
                var custSql = "CALL create_customer('" + customer.firstname + "', '" + customer.lastname + "', '" +  customer.email + "', '" + customer.password + "', " + customer.securityQuestion + ", '" + customer.securityAnswer + "')";
                connection.query(custSql, function (error, results)
                {
                    if (error)
                    {
                        console.log('error in executing sql: ', error);
                        return callback(error);
                    }
                    console.log(JSON.stringify(results));
                    callback(null, results[0][0].id);
                });
            }
        });
    });
}

function editCustomer(callback, connection, customer)
{
    process.nextTick(function()
    {
        var sqlEditCust = 'call edit_customer('+customer.id+',"'+customer.firstname+'","'+customer.lastname+'","'+customer.email+'",'+customer.phone+',"'+customer.city+'","'+customer.street+'","'+customer.hno+'",'+customer.plz+',"'+customer.state+'","'+customer.country+'");';
        console.log(sqlEditCust);
        connection.query(sqlEditCust, function(err, results)
        {
            if(err)
            {

            }
            else
            {
                callback(null, results[0].id);
            }
        });
    });
}

function editDP(callback, connection, customer)
{
    process.nextTick(function()
    {
        var sqlEditDP = 'UPDATE customer SET profilepicture = "'+customer.path+'" WHERE id = '+customer.id+';';
        connection.query(sqlEditDP, function(err, result)
        {
            if(err)
            {

            }
            else
            {
                callback(null, result);
            }
        });
    });
}
