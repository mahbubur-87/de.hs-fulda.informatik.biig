/*
File Name: controllerSignIn.js

Description:
This is a sign in controller which communicates with model layer 
to perform sign in operations. After getting results from model layer, 
it processes results and finally send a response to client using view
rendering engine ejs. 

Authors:
Swetaketu Majumder, Rohan Deo, Aleks, Akhila
*/

var bcrypt = require('bcrypt-nodejs');
var mUser = require('../models/modelUser');
var mType = require('../models/modelType');
var cookieConfigs = require('../../config/cookieConfigs');

module.exports =
    {
        setConnection: setConnection,
        doSignIn: doSignIn,
        loadForgotpassword: loadForgotpassword,
        forgotPassword: forgotPassword,
        resetPassword: resetPassword,
        doSignInAleks: doSignInAleks
    };

var connection;

function setConnection(conn)
{
    connection = conn;
}

function doSignIn(req, res)
{
    mUser.findByEmail(connection, req.body.inputEmail, function(err, user)
    {
        if(err)
        {
            res.cookie('signinerror', "Error doing DB Operation.", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else if(!user)
        {
            res.cookie('signinerror', "User does not exist. Please register first.", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else
        {
            if(bcrypt.compareSync(req.body.inputPassword, user.password))
            {
                var cookieName = user.customer ? 'customer' : (user.companyadmin ? 'company' : 'employee');
                var value = (user.customer ? user.customer : (user.companyadmin ? user.companyadmin : user.employee)) * 15122017;
                res.cookie(cookieName, value, cookieConfigs.long);
                res.redirect(req.header('Referer'));
            }
            else
            {
                res.cookie('signinerror', "Wrong Password.", cookieConfigs.short);
                res.redirect(req.header('Referer'));
            }
        }
    });
}

function doSignInAleks(req, res)
{
    mUser.findByEmail(connection, req.body.inputEmail, function(err, user)
    {
        if(err)
        {
            res.send(false);
        }
        else if(!user)
        {
            res.send(false);
        }
        else
        {
            if(bcrypt.compareSync(req.body.inputPassword, user.password))
            {
                res.send(user);
            }
            else
            {
                res.send(false);
            }
        }
    });
}


function resetPassword(req, res)
{
    // (, s)
    mUser.resetPassword(connection, req.body.userid, bcrypt.hashSync(req.body.password), function(err)
    {
        if(err)
        {
            res.cookie('message', "Error doing DB operation", cookieConfigs.short);
        }
        else
        {
            res.cookie('message', "Your password has been successfully reset", cookieConfigs.short);
        }
        res.redirect('/');
    });
}

function forgotPassword(req, res)
{
    mUser.findByEmail(connection, req.body.email, function(err, user)
    {
        if(err)
        {
            res.cookie('message', "Error doing DB Operation.", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else if(!user)
        {
            res.cookie('message', "User does not exist. Please register first.", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else
        {
            if(user.securityquestion == req.body.securityQuestion && bcrypt.compareSync(req.body.securityAnswer, user.securityanswer))
            {
                res.render('resetpassword', {userId: user.id});
            }
            else
            {
                res.cookie('message', "Wrong Input.", cookieConfigs.short);
                res.redirect(req.header('Referer'));
            }
        }
    });
}

function loadForgotpassword(req, res)
{
    var toastMessage;
    if(req.signedCookies['message'])
    {
        toastMessage= req.signedCookies['message'];
        res.clearCookie('message');
    }
    mType.findValuesByType(function(err, results)
    {
        if(err)
        {

        }
        else
        {
            res.render('forgotpassword', {secQ : results, message: toastMessage});
        }
    }, connection, 'SECURITY_QUES');
}
