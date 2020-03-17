/*
File Name: modelUser.js

Description:
This is a user model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Swetaketu Majumder
*/

module.exports = {
    findByEmail : findByEmail,
    findById    : findById,
    resetPassword : resetPassword
};

function findByEmail (connection, email, callback)
{
   process.nextTick(function ()
   {
        var usrSql = "SELECT u.* FROM user u WHERE u.email = '" + email + "'";

        connection.query(usrSql, function (error, results) {
            if (error) {
                console.log('error in executing sql: ', error);
                return callback(error);
            }

            callback(null, results[0]);
        });
    });
}

function findById (connection, id, callback)
{
   process.nextTick(function () {
        var usrSql = "SELECT u.* FROM user u WHERE u.id = " + id;

        connection.query(usrSql, function (error, results) {
            if (error) {
                console.log('error in executing sql: ', error);
                return callback(error);
            }

            callback(null, results[0]);
        });
    });
}

function resetPassword(connection, id, password, callback)
{
   process.nextTick(function ()
   {
     var sqlEditPwd = "UPDATE `user` SET `password` =  '"+password + "' WHERE id = " +id;
     connection.query(sqlEditPwd, function(error, results)
     {
       if(error)
       {
         callback(error);
       }
       else
       {
         // Handle in Controller
         callback(null);
       }
     });
   });
}
