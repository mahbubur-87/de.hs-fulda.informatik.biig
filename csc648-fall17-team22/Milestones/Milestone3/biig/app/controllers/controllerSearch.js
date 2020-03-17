/*
File Name: controllerSearch.js

Description:
This is a search controller which communicates with model layer
to perform property search and other operations. After getting results from model layer,
it processes results and finally send a response to client using view
rendering engine ejs.

Authors:
Mahbubur Rahman, Akhila
*/

var mProperty = require('../models/modelProperty');
var mCustomer = require('../models/modelCustomer');
var mCompany = require('../models/modelCompany');
var mEmployee = require('../models/modelEmployee');
var mCustomerFavorite = require('../models/modelCustomerFavorite');

module.exports =
{
    setConnection: setConnection,
    doSearch: doSearch,
    renderPropertyDetails: renderPropertyDetails,
    addToFavorite: addToFavorite,
    doSearchFinder: doSearchFinder,
    removeFromFavorite: removeFromFavorite,
};

var connection;

function setConnection(conn)
{
    connection = conn;
}

function addToFavorite (req, res) {
    GetRequiredValues(req, res, function(user, message)
	{
        var propertyId = req.query.id;
        mCustomerFavorite.addToFavorite(function (error, results) {
            if (error) {
              console.log('error[addToFavorite]: ', error);
            }
            var favProperties= results;
            for(var i = 0;i < favProperties.length;i++) {
              favProperties[i].customer_favorite=1;
            }
            RecommendProperty(favProperties,user,function(reccProperties){
              var sentResults={
                reccProperties:reccProperties,
                userProfile:user
              }
              res.send(sentResults);
            });
        }, connection, user.customer, propertyId);
    });
}
function removeFromFavorite (req, res) {
    GetRequiredValues(req, res, function(user, message)
	{
        var propertyId = req.query.id;
        mCustomerFavorite.removeFromFavorite(function (error, results) {
            if (error) {
              console.log('error[removeFromFavorite]: ', error);
            }

            var favProperties= results;
            for(var i = 0;i < favProperties.length;i++) {
              favProperties[i].customer_favorite=1;
            }
            RecommendProperty(favProperties,user,function(reccProperties){
              var sentResults={
                reccProperties:reccProperties,
                userProfile:user
              }
              res.send(sentResults);
            });
        }, connection, user.customer, propertyId);
    });
}

function doSearch(req, res)
{
	GetRequiredValues(req, res, function(user, message)
	{
        getPropertyFilters(function (error, results) {
            if (error) {
                console.log('error[get property filters]: ', error);
            }

            GetSearchResultsAndRender(req, res, user, message, results);
        });
	});
}
function doSearchFinder(req,res){
  GetRequiredValues(req, res, function(user, message)
	{
        getPropertyFilters(function (error, results) {
            if (error) {
                console.log('error[get property filters]: ', error);
            }

            GetSearchResults(req, res, user, message, results);
        });
	});
}

function getPropertyFilters (callback) {
    process.nextTick (function () {
        mProperty.getPropertyFilters(callback, connection, 1, 1);
    });
}

function GetSearchResultsAndRender(req, res, user, toastMessage, propertyFilters)
{
	process.nextTick (function ()
    {
        var searchOptions =
		{
			key: req.query.key,
            location: req.query.location,
            size: req.query.size,
            furnishingState: req.query.furnishingState,
            numberOfRooms: req.query.numberOfRooms,
            sort: req.query.sort
		};

        mProperty.search(function(error, results)
    	{
        	if (error)
        	{
            	console.log("error[search property]: ", error);
			    }
          RecommendProperty(results,user,function(reccProperties){
              res.render('propertyFinder',
              {
                    userProfile: user,
                    message: toastMessage,
                    key: searchOptions.key ? searchOptions.key : '',
                      sort: searchOptions.sort ? searchOptions.sort : 'Newest First',
                      location: searchOptions.location ? searchOptions.location : '',
                      size: searchOptions.size ? searchOptions.size : '',
                      furnishingState: searchOptions.furnishingState ? searchOptions.furnishingState : '',
                      numberOfRooms: searchOptions.numberOfRooms ? searchOptions.numberOfRooms : '',
                    locations: propertyFilters[0] ? propertyFilters[0] : [],
                      sizes: propertyFilters[1] ? propertyFilters[1] : [],
                      furnishingStates: propertyFilters[2] ? propertyFilters[2] : [],
                      sortOptions: propertyFilters[3] ? propertyFilters[3] : [],
                    properties: results ? results : [],
                    reccProperties:reccProperties?reccProperties:[]
                });

              });
		}, connection, searchOptions, user ? user.customer : null);
	});
}
function GetSearchResults(req, res, user, toastMessage, propertyFilters)
{
	process.nextTick (function ()
    {
        var searchOptions =
		{
			key: req.query.key,
            location: req.query.location,
            size: req.query.size,
            furnishingState: req.query.furnishingState,
            numberOfRooms: req.query.numberOfRooms,
            sort: req.query.sort
		};

        mProperty.search(function(error, results)
    	{
        	if (error)
        	{
            	console.log("error[search property]: ", error);
			    }
        var sentResults={
          properties:results,
          userProfile:user
        }
        res.send(sentResults);
		}, connection, searchOptions, user ? user.customer : null);
	});
}

function GetRequiredValues(req, res, callback)
{
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
                callback(null, toastMessage);
			}
			else
			{
                callback(customer, toastMessage);
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
				callback(null, toastMessage);
			}
			else
			{
				callback(companyadmin, toastMessage);
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
				callback(null, toastMessage);
			}
			else
			{
				callback(employee, toastMessage);
			}
		}, connection, id);

	}
	else
	{
		callback(null, toastMessage);
	}
}

function renderPropertyDetails(req, res)
{
	GetRequiredValues(req, res, function(user, toastMessage)
	{
		mProperty.findById(function(error, results)
		{
			if (error)
			{
				console.log("error: ", error);
			}
      console.log(JSON.stringify(results));
			res.render('propertydetails', {
				property: results ? results : {},
				userProfile: user,
				message: toastMessage
			});
		}, connection, req.query.id);
	});
}
function RecommendProperty(properties,user,callback){
      var allProperties=[];
      var favProperties=[];
      var reccProperties=[];
      for(var i = 0;i < properties.length;i++) {
        if(properties[i].customer_favorite==1){
          favProperties.push(properties[i]);
        }
      }
      mProperty.getAllProperties(function(err, results)
      {
          if(err)
          {
              console.log(err);
             callback(reccProperties);
          }
          else
          {
            allProperties=results;
            JaccardAlgorithm(favProperties,allProperties,function(reccProperties){
              callback(reccProperties);
            });
          }
        }, connection);

}
//JaccardAlgorithm to find similarity between properties and predict properties that user like
function JaccardAlgorithm(favProperties,allProperties,callback){
  var reccProperties = [];
  var jaccPositive = 0, jaccAll = 0, jaccCoeff = 0;
  if(favProperties.length>0){
        for(var i = 0;i < allProperties.length;i++) {
          if(!allProperties[i].jaccCoeff){
            allProperties[i].jaccCoeff=-1;
            allProperties[i].customer_favorite=0;
          }
          for(var j = 0;j < favProperties.length;j++) {
            if(allProperties[i].id==favProperties[j].id)
            {
                //console.log(allProperties[i].price);
                allProperties[i].jaccCoeff= 0 ;
                allProperties[i].customer_favorite=1;
            }
            else if(allProperties[i].jaccCoeff!=0){
              jaccPositive = 0, jaccAll = 0, jaccCoeff = 0;
                  allProperties[i].customer_favorite=0;
                  //size
                  if(Math.abs(favProperties[j].size-allProperties[i].size)<5){
                    jaccPositive++;
                    jaccAll++;
                  }
                  else {
                      jaccAll++;
                  }
                  //price
                  if(Math.abs(favProperties[j].price-allProperties[i].price)<10000){
                    jaccPositive++;
                    jaccAll++;
                  }
                  else {
                      jaccAll++;
                  }
                  //number of Rooms
                  if(Math.abs(allProperties[i].numberofrooms - favProperties[j].numberofrooms)<2 ){
                    jaccPositive++;
                    jaccAll++;
                  }
                  else{
                    jaccAll++;
                  }
                  //furnishingstate
                  if(allProperties[i].furnishingstate == favProperties[j].furnishingstate){
                    jaccPositive++;
                    jaccAll++;
                  }
                  else{
                    jaccAll++;
                  }
                  //city
                  if(allProperties[i].city == favProperties[j].city ){
                    jaccPositive++;
                    jaccPositive++;
                    jaccAll++;
                  }
                  else{
                    jaccAll++;
                  }

                  jaccCoeff=jaccPositive/jaccAll;
                  if(jaccCoeff > allProperties[i].jaccCoeff)
                      allProperties[i].jaccCoeff=jaccCoeff;

            }
          }
        }
        allProperties.sort(function(a, b){
          return b.jaccCoeff-a.jaccCoeff
        });
    }
    for(var i = 0;i <5;i++) {
        reccProperties[i]=allProperties[i];
    }
    callback(reccProperties);

}
