/*
File Name: modelMessage.js

Description:
This is a message model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Rohan Deo
*/

module.exports=
{
  save: save,
  getEmpMessage: getEmpMessage,
  getCustMessage: getCustMessage,
  getMessages: getMessages
}

function save(callback,connection,msg,id)
{
  console.log("\n\nCustomer ID: "+id);
  process.nextTick(function()
  {
    var msgquery = 'insert into message(message, fromuser, touser, messagedatetime) values("'+msg.message+'", '+id+', '+msg.id+', now())';
    connection.query(msgquery, function(error, results)
    {
        if (error)
        {
            console.log('error in executing sql: ', error);
            return callback(error);
        }

        callback(null, results);
    });
  });
}

function getEmpMessage(callback, connection, userId)
{
  process.nextTick(function()
  {
    var msgQry = 'select msg.touser as touser, msg.fromuser as fromuser, cst.user as cuser, cst.firstname, cst.lastname from message msg, customer cst where msg.touser = '+userId+' and msg.fromuser = cst.`user` GROUP BY msg.fromuser';
    connection.query(msgQry, function(err, result)
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

function getCustMessage(callback, connection, userId)
{
  process.nextTick(function()
  {
    var msgQry = 'select msg.touser as touser, msg.fromuser as fromuser, emp.user as euser, emp.firstname, emp.lastname from message msg, employee emp where msg.touser = '+userId+' and msg.fromuser = emp.`user` GROUP BY msg.fromuser';
    connection.query(msgQry, function(err, result)
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

function getMessages(callback, connection, touser, fromuser)
{
  process.nextTick(function()
  {
    var msgs = 'select msg.message as messages, msg.fromuser as fromuser, msg.touser as touser  from message msg where (msg.touser = touser and msg.fromuser = fromuser) or (msg.touser = fromuser and msg.fromuser = touser)';
    connection.query(msgs, function(err, result)
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
