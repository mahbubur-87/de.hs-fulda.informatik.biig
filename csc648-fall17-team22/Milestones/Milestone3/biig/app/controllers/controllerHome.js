/*
File Name: controllerHome.js

Description:
This is a home controller which communicates with model layer
to perform static page render and some business operations. After getting results from model layer, it processes results and finally send a response to client using view
rendering engine ejs.

Authors:
Swetaketu Majumder, Rohan Deo, Aleks, Akhila, Mahdis
*/

var bcrypt = require('bcrypt-nodejs');
var cookieParser = require('cookie-parser');
var mCustomer = require('../models/modelCustomer');
var mCompany = require('../models/modelCompany');
var mEmployee = require('../models/modelEmployee');
var mProperty = require('../models/modelProperty');
var mContactUs = require('../models/modelContactUs');
var cookieConfigs = require('../../config/cookieConfigs');
var connection;

module.exports =
{
	setConnection: setConnection,
	renderHome: renderHome,
	renderAboutUs: renderAboutUs,
	renderContactUs: renderContactUs,
	contact: contact
};

function setConnection(conn)
{
	connection = conn;
}

function getPropertyFilters (callback) {
    process.nextTick (function () {
        mProperty.getPropertyFilters(callback, connection, 0, 0);
    });
}

function renderHome(req, res)
{
    getPropertyFilters(function (error, results) {
            if (error) {
                console.log('error[get property filters]: ', error);
            }

            render('Home', req, res, results);
        });
}

function renderAboutUs(req, res)
{
	render('AboutUs', req, res);
}

function renderContactUs(req, res)
{
	render('contactus', req, res);
}

function render(filename, req, res, propertyFilters)
{
	console.log("\nIN RENDER STATICS: "+filename);
	var toastMessage;
	if(req.signedCookies['message'])
	{
		toastMessage= req.signedCookies['message'];
		res.clearCookie('message');
	}
	if(req.signedCookies['customer'])
	{
		var id = req.signedCookies['customer'] / 15122017;
		mCustomer.findById(function(err, customer)
		{
			if(err)
			{
				res.clearCookie('customer');
				res.render(filename, {
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                                     });
			}
			else
			{
				res.render(filename, {
                    userProfile: customer,
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                });
			}
		}, connection, id);
	}
	else if(req.signedCookies['company'])
	{
		var id = req.signedCookies['company'] / 15122017;
		mCompany.findById(function(err, companyadmin)
		{
			if(err)
			{
				res.clearCookie('company');
				res.render(filename, {
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                });
			}
			else
			{
				res.render(filename, {
                    userProfile: companyadmin,
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                });
			}
		}, connection, id);
	}
	else if(req.signedCookies['employee'])
	{
		var id = req.signedCookies['employee'] / 15122017;
		mEmployee.findById(function(err, employee)
		{
			if(err)
			{
				res.clearCookie('employee');
				res.render(filename, {
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                                     });
			}
			else
			{
				res.render(filename, {
                    userProfile: employee,
                    message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
                });
			}
		}, connection, id);
	}
	else
	{
		console.log("IN ELSE OF RENDER STATIC");
		var signinerr;
		if(req.signedCookies['signinerror'])
		{
			signinerr= req.signedCookies['signinerror'];
			res.clearCookie('signinerror');
			console.log(signinerr);
		}
		res.render(filename, {
            signinerror: signinerr,
            message: toastMessage,
                    sizes: propertyFilters && propertyFilters[0] ? propertyFilters[0] : [],
                furnishingStates: propertyFilters && propertyFilters[1] ? propertyFilters[1] : []
        });
	}
}

function contact(req, res){
	mContactUs.saveFeedbacks(req.body.name,req.body.email,req.body.message,connection,function(message){
		if(message == "Failed"){
			res.cookie('message','Message did not send successfully',cookieConfigs.short);
		}
		else {
			console.log('message sent');
			res.cookie('message', 'Message sent successfully', cookieConfigs.short);
		}
		res.redirect(req.header('Referer'));
	});
}
