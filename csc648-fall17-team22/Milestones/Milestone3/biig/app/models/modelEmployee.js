/*
File Name: modelEmployee.js

Description:
This is a employee model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Swetaketu Majumder
*/

var mUser = require('../models/modelUser');

module.exports=
{
   addEmployee : addEmployee,
   getEmployees: getEmployees,
   findById    : findById,
   removeByEmployeeId: removeByEmployeeId,
   editDP: editDP,
   editEmployee: editEmployee
};

function addEmployee (callback, connection, employee)
{
  console.log("\n\nInside addEmployee\n\n");
    process.nextTick(function ()
    {
        mUser.findByEmail(connection, employee.email, function(err, user)
        {
          console.log("\n\nInside findByEmail\n\n");
            if(err)
            {
                console.log(err);
            }
            else if(user)
            {
                callback(null, null, "An account already exists with the same email.");
            }
            else
            {

                var custSql = "CALL create_employee(" +employee.companyadminid+ ", '" + employee.firstname + "', '" + employee.lastname + "', '" +  employee.email + "', '" + employee.password + "', " + employee.securityQuestion + ", '" + employee.securityAnswer + "')";
                console.log(custSql);
                connection.query(custSql, function (error, results)
                {
                    if (error)
                    {
                        console.log('error in executing sql: ', error);
                        return callback(error);
                    }

                    callback(null, results[0]);
                });
            }
        });
    });
}

function getEmployees(callback, connection, companyadminid)
{
    process.nextTick(function ()
    {
      console.log("\n\nInside getEmployee\n\n");
        var sqlqry = 'select emp.*, u.email from employee emp, `user` u where emp.company = (select company from employee e where e.id = '+companyadminid+') and u.id = emp.`user` and not emp.id = '+companyadminid;
        console.log(sqlqry);
        connection.query(sqlqry, function(err, results)
        {
            if(err)
            {
                console.log(err);
            }
            else
            {
              console.log(JSON.stringify(results));
                callback(null, results);
            }
        });
    });
}

var employBaseSql2 = "select e.id as employeeid, e.*, u.*, addr.* from employee e left join `user` u on e.`user` = u.id left join address addr on e.address = addr.id ";
function findById (callback, connection, id)
{
    process.nextTick (function ()
    {
        console.log("\n\nINSIDE EMPLOYEE  FIND BY ID: "+id+"\n\n");
        var custSql = employBaseSql2 + " WHERE e.id = " + id;

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

function removeByEmployeeId(callback, connection, id)
{
    process.nextTick(function()
    {
        var queryStr = "delete from `user` where employee="+id;
        connection.query(queryStr, function (err, results)
        {
            if (err)
            {
                console.log(err);
                return callback(err);
            }
            callback(null, results);
        });
    });
}

function editDP(callback, connection, employee)
{
    process.nextTick(function()
    {
        var sqlEditDP = 'UPDATE employee SET profilepicture = "'+employee.path+'" WHERE id = '+employee.id+';';
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

function editEmployee(callback, connection, employee)
{
    process.nextTick(function()
    {
        var sqlEditCust = 'call edit_employee('+employee.id+',"'+employee.firstname+'","'+employee.lastname+'","'+employee.email+'",'+employee.phone+',"'+employee.city+'","'+employee.street+'","'+employee.hno+'",'+employee.plz+',"'+employee.state+'","'+employee.country+'");';
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


