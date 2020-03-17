/*
File Name: controllerMessage.js

Description:
This is a message controller which communicates with model layer 
to perform message send and reply operations. After getting results from model layer, 
it processes results and finally send a response to client using view
rendering engine ejs. 

Authors:
Swetaketu Majumder, Rohan Deo
*/

var mMessage = require('../models/modelMessage');
var cookieParser = require('cookie-parser');
var cookieConfigs = require('../../config/cookieConfigs');
var mCustomer = require('../models/modelCustomer');
var mEmployee = require('../models/modelEmployee');

module.exports =
{
   setConnection: setConnection,
   sendMessage: sendMessage,
   replyMessage: replyMessage,
   getMessage: getMessage
};

var connection;

function setConnection(conn)
{
    connection = conn;
}

function sendMessage(req,res)
{

  console.log("\n\nInside sendMessage function+"+JSON.stringify(req.body));
  var msg=
  {
    id: req.body.agentid,
    message: req.body.message
  }

  if(req.signedCookies['customer'])
  {
    var uid = null;
    var cid = req.signedCookies['customer'] / 15122017;
    console.log("\n\nCUSTOMER FOUND IN COOKIE: "+cid+"\n\n");
    mCustomer.findUserId(function(err, uid)
    {
        if(err)
        {
            console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
        }
        else
        {
          console.log("\n\nSuccessful!!\n\n");
          console.log("\n\nUSERID:"+uid.id);
          mMessage.save(function(err, messageid)
          {
            if(err)
            {
              res.cookie('message', "Unable to send message", cookieConfigs.short);
            }
            else
            {
              res.cookie('message', "Message successfully sent", cookieConfigs.short);
              res.redirect(req.header('Referer'));
            }
          },connection,msg,uid.id);

        }
    }, connection, cid);

   }
   else
   {
     console.log("\n\nin else part of message cookie\n\n");
     res.cookie('message', "You have to register before sending the message", cookieConfigs.short);
   }
}

function replyMessage(req,res)
{

  console.log("\n\nInside replyMessage function+"+JSON.stringify(req.body));


  if(req.signedCookies['customer'])
  {
    var msg=
    {
      id: req.body.euser,
      message: req.body.reply
    }
    console.log("\n\nEUSER:"+msg.id+"\n\n");
    var uid = null;
    var cid = req.signedCookies['customer'] / 15122017;
    console.log("\n\nCUSTOMER FOUND IN COOKIE: "+cid+"\n\n");
    mCustomer.findUserId(function(err, uid)
    {
        if(err)
        {
            console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
        }
        else
        {
          console.log("\n\nSuccessful!!\n\n");
          console.log("\n\nUSERID:"+uid.id);
          mMessage.save(function(err, messageid)
          {
            if(err)
            {
              res.cookie('message', "Unable to send message", cookieConfigs.short);
            }
            else
            {
              res.cookie('message', "Message successfully sent", cookieConfigs.short);
              res.redirect(req.header('Referer'));
            }
          },connection,msg,uid.id);

        }
    }, connection, cid);

   }
   else if(req.signedCookies['employee'])
   {
     var msg=
     {
       id: req.body.cuser,
       message: req.body.reply
     }
     var uid = null;
     var cid = req.signedCookies['employee'] / 15122017;
     console.log("\n\nEMPLOYEE FOUND IN COOKIE: "+cid+"\n\n");
     mEmployee.findById(function(err, uid)
     {
         if(err)
         {
             console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
         }
         else
         {
           console.log("\n\nSuccessful!!\n\n");
           console.log("\n\nUSERID:"+uid.user);
           mMessage.save(function(err, messageid)
           {
             if(err)
             {
               res.cookie('message', "Unable to send message", cookieConfigs.short);
             }
             else
             {
               res.cookie('message', "Message successfully sent", cookieConfigs.short);
               res.redirect(req.header('Referer'));
             }
           },connection,msg,uid.user);

         }
     }, connection, cid);

    }
   else
   {
     console.log("\n\nin else part of message cookie\n\n");
     res.cookie('message', "You have to register before sending the message", cookieConfigs.short);
   }
}

function getMessage(req,res)
{

  var info=
  {
    touser: req.body.touser,
    fromuser: req.body.fromuser
  }
  mMessage.getMessages(function(err, messages)
  {
   if(err)
   {
     console.log("\n\n Error\n\n");
   }
   else
   {
     console.log("\n\nSuccess \n\n");
      res.send(messages);
   }
 }, connection, info.touser, info.fromuser);

}
