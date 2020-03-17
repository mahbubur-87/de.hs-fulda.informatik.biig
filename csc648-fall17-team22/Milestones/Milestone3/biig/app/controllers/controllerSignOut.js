/*
File Name: controllerSignOut.js

Description:
This is a sign out controller which communicates with model layer 
to perform sign out operations. After getting results from model layer, 
it processes results and finally send a response to client using view
rendering engine ejs. 

Authors:
Swetaketu Majumder
*/

module.exports =
{
	doSignOut: doSignOut
};

function doSignOut(req, res)
{
	res.clearCookie('customer');
	res.clearCookie('employee');
	res.clearCookie('company');
	res.redirect(req.header('Referer'));
}
