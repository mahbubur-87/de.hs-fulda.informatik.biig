/*
File Name: modelCompany.js

Description:
This is a company model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Swetaketu Majumder
*/

var mUser = require('./modelUser');
var mEmployee = require('./modelEmployee');

module.exports = {
    addCompany: addCompany,
    findByUserId: findByUserId,
    findById: findById
};

var empBaseSql2 = "select * from `user` u, employee e where e.`user` = u.id ";

function findById (callback, connection, id) 
{    
    process.nextTick (function () 
    {
        var empSql = empBaseSql2 + " AND e.id = " + id;
        
            connection.query(empSql, function (err, results) 
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

function findByUserId (callback, connection, userId)
{
    process.nextTick (function ()
    {
        var custSql = "SELECT e.* FROM employee e WHERE e.user = " + userId;

        connection.query(custSql, function (err, results)
        {
            if (err) {
                console.log(err);
                return callback(err);
            }

            callback(null, results[0]);
        });
    });
}

function addCompany (callback, connection, company)
{
    process.nextTick(function () 
    {
        mUser.findByEmail(connection, company.email, function(err, user)
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
                var empSql ="CALL create_company_with_admin('"+ company.name + "', '" + company.firstname + "', '" + company.lastname + "', '" + company.email + "', '" + company.password + "', " + company.securityQuestion + ", '" + company.securityAnswer + "')";

                connection.query(empSql, function (error, results)
                {
                    if (error)
                    {
                        console.log('error in executing sql: ', error);
                        return callback(error);
                    }
                    callback(null, results[0][0].id);
                });   
            }       
        }); 
    });
}
