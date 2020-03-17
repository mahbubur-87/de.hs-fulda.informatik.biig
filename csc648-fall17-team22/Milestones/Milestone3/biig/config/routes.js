var cHome = require('../app/controllers/controllerHome');

var cSignUp = require('../app/controllers/controllerSignUp');
var cSignIn = require('../app/controllers/controllerSignIn');
var cSignOut = require('../app/controllers/controllerSignOut');

var cDashboard = require('../app/controllers/controllerDashboard');

var cSearch = require('../app/controllers/controllerSearch');
var cMessage = require('../app/controllers/controllerMessage');
var cAPI = require('../app/controllers/controllerAPI');

module.exports = function (app, connection) {

    cHome.setConnection(connection);
    cSearch.setConnection(connection);
    cSignUp.setConnection(connection);
    cSignIn.setConnection(connection);
    cDashboard.setConnection(connection);
    cMessage.setConnection(connection);
    cAPI.setConnection(connection);

    // Entry Point, both for local and Server
    app.get('/', cHome.renderHome);

    app.get('/aboutus', cHome.renderAboutUs);

    app.get('/contactus', cHome.renderContactUs);

    app.post('/contactus', cHome.contact);

    app.get('/signup', cSignUp.signupRenderForm);

    app.post('/signupcustomer', cSignUp.signupCustomer);

    app.post('/signupcompany', cSignUp.signupCompany);

    app.post('/signupagent', cSignUp.signupListingAgent);

    app.get('/dashboard', cDashboard.renderDashboard);

    app.post('/signin', cSignIn.doSignIn);

    app.post('/signinAleks', cSignIn.doSignInAleks);

    app.get('/logout', cSignOut.doSignOut);

    app.get('/search', cSearch.doSearch);

    app.get('/searchfinder', cSearch.doSearchFinder);

    app.get('/property', cSearch.renderPropertyDetails);

    app.post('/addproperty', cDashboard.addProperty);

    app.post('/uploadpropertyimage', cDashboard.uploadPropertyImage);

    // Entrypoint for Password
    app.get('/loadforgotpassword', cSignIn.loadForgotpassword);

    app.post('/forgotPassword', cSignIn.forgotPassword);

    app.post('/resetpassword', cSignIn.resetPassword);

    app.post('/deleteagent', cDashboard.removeListingAgent);

    app.post('/message', cMessage.sendMessage);

    app.get('/customer-favorite', cSearch.addToFavorite);

    app.get('/customer-favorite/remove', cSearch.removeFromFavorite);

    app.post("/uploaddp", cDashboard.uploadDP);

    app.post('/uploaddptodb', cDashboard.saveDPToDB);

    app.post('/editcustomer', cDashboard.editCustomer);

    app.post('/reply', cMessage.replyMessage);

    app.post('/getmsg', cMessage.getMessage);

    app.get('/employees/:id/dashboard/:year/monthly-sales', cDashboard.getAgentMonthlySalesOfYear);

    app.get('/employees/:id/dashboard/:year/monthly-sales-count', cDashboard.getAgentMonthlySalesCountOfYear);

    app.get('/employees/:id/dashboard/yearly-total-sales', cDashboard.getAgentYearWiseTotalSales);

    app.get('/employees/:id/dashboard/yearly-total-sales-count', cDashboard.getAgentYearWiseTotalSalesCount);

    app.post('/editemployee', cDashboard.editEmployee);

    app.post('/addsales', cDashboard.addSales);

    app.post('/propertyprice', cDashboard.predictPrice);

    //APIs for mobile app
    app.post('/user/login', cAPI.authenticateUser);

    app.post('/user/signup', cAPI.usersignup);
    
    app.get('/type/:typeName/values', cAPI.getTypeValues);
    
    app.post('/image', cAPI.uploadImage);
    
    app.get('/listing-agent/:id/properties', cAPI.getProperties);
    
    app.get('/property/filter-options', cAPI.getPropertyFilterOptions);
    
    app.get('/property/search', cAPI.searchproperty);
    
    app.get('/property/:id', cAPI.getProperty);
    
    app.post('/property', cAPI.addProperty);

    app.get('/getrpiip', cAPI.getRpiIP);
    
    app.get('*', function(req, res)
    {
        res.status(404).render('404');
    });
}
