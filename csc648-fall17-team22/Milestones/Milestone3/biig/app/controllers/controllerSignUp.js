/*
File Name: controllerSignUp.js

Description:
This is a sign up controller which communicates with model layer 
to perform sign up operations. After getting results from model layer, 
it processes results and finally send a response to client using view
rendering engine ejs. 

Authors:
Swetaketu Majumder, Rohan Deo, Aleks, Akhila
*/

var bcrypt = require('bcrypt-nodejs');
var mType = require('../models/modelType');
var mCustomer = require('../models/modelCustomer');
var mCompany = require('../models/modelCompany');
var mEmployee = require('../models/modelEmployee');
var cookieConfigs = require('../../config/cookieConfigs');
var connection;

module.exports =
{
    setConnection: setConnection,
    signupCustomer: signupCustomer,
    signupCompany: signupCompany,
    signupListingAgent: signupListingAgent,
    signupRenderForm: signupRenderForm
};

function setConnection(conn)
{
    connection = conn;
}

function signupRenderForm(req, res)
{
    var toastMessage;
	if(req.signedCookies['message'])
	{
		toastMessage= req.signedCookies['message'];
		res.clearCookie('message');
	}
    mType.findValuesByType(function(err, values)
    {
        if(err)
        {
            console.log("\n\nERROR IN GETTING TYPES\n\n");
        }
        else
        {
            console.log("\nIN SIGN UP RENDER usertype= "+req.query.userType);
            res.render(req.query.userType === 'customer' ? 'signUp_customer' : 'signUp_company', {secQ: values, message: toastMessage});
        }
    }, connection, 'SECURITY_QUES', null);
}

function signupCustomer(req, res)
{
    console.log("\n\nINSIDE SIGNUP CUSTOMER\n\n");
    var customer =
    {
        firstname: req.body.firstname,
        lastname: req.body.lastname,
        email: req.body.email,
        password: bcrypt.hashSync(req.body.password),
        securityQuestion: req.body.securityQuestion,
        securityAnswer: bcrypt.hashSync(req.body.securityAnswer)
    };
    console.log("\n\n"+JSON.stringify(customer)+"\n\n");
    mCustomer.addCustomer(function(err, custID, message)
    {
        if(err)
        {
            res.cookie('message', "Error adding customer", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else if(message)
        {
            res.cookie('message', message, cookieConfigs.short);
            res.redirect('/signup/?userType=customer');
        }
        else
        {
            console.log("\n\nSUCCESS ADD CUSTOMER:"+custID+"\n\n");
            res.cookie('customer', custID * 15122017, cookieConfigs.long);
            res.redirect('/dashboard');
        }
    }, connection, customer);
}

function signupCompany(req, res)
{
    console.log("\n\nINSIDE COMPANY REG\n\n");
    var company =
    {
        name: req.body.name,
        firstname: req.body.firstname,
        lastname: req.body.lastname,
        email: req.body.email,
        password: bcrypt.hashSync(req.body.password),
        securityQuestion: req.body.securityQuestion,
        securityAnswer: bcrypt.hashSync(req.body.securityAnswer)
    }
    mCompany.addCompany(function(err, empID, message)
    {
        if(err)
        {
            res.cookie('message', "Error adding customer", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
        else if(message)
        {
            res.cookie('message', message, cookieConfigs.short);
            res.redirect('/signup/?userType=company');
        }
        else
        {
            console.log("\n\nSUCCESS ADD COMPANY:"+empID+"\n\n");
            res.cookie('company', empID * 15122017, cookieConfigs.long);
            res.redirect('/dashboard');
        }
    }, connection, company);
}

function signupListingAgent(req, res)
{
    console.log("\n\nINSIDE COMPANY REG\n\n");
    if(req.signedCookies['company'])
    {
        var id = req.signedCookies['company'] / 15122017;
        var employee =
        {
            companyadminid: id,
            firstname: req.body.firstname,
            lastname: req.body.lastname,
            email: req.body.email,
            password: bcrypt.hashSync(req.body.password),
            securityQuestion: req.body.securityQuestion,
            securityAnswer: bcrypt.hashSync(req.body.securityAnswer)
        }
        mEmployee.addEmployee(function(err, results, message)
        {
            if(err)
            {
                res.cookie('message', "Error adding customer", cookieConfigs.short);
                res.redirect(req.header('Referer'));
            }
            else if(message)
            {
                res.cookie('message', message, cookieConfigs.short);
                res.redirect(req.header('Referer'));
            }
            else
            {
                console.log("\n\nSUCCESS ADD EMPLOYEE: "+JSON.stringify(results)+"\n\n");
                mEmployee.getEmployees(function(err, employees)
                {
                    res.send(employees);
                    console.log("\n\nIn GetEmployees\n\n");
                }, connection, employee.companyadminid);
            }
        }, connection, employee);
    }
    else
    {
        res.cookie('message', "You are not allowed to create listing agents", cookieConfigs.short);
        res.redirect(req.header('Referer'));
    }
}
