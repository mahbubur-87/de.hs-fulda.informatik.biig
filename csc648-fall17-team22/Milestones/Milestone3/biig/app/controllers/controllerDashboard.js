/*
File Name: controllerDashboard.js

Description:
This is a dashboard controller which communicates with model layer
to perform loading interactive dashboard operations. After getting results from model layer,
it processes results and finally send a response to client using view
rendering engine ejs.

Authors:
Mahbubur Rahman, Swetaketu Majumder, Rohan Deo, Aleks, Akhila
*/

var cookieParser = require('cookie-parser');
var multer = require('multer');
var mType = require('../models/modelType');
var mCustomer = require('../models/modelCustomer');
var mCompany = require('../models/modelCompany');
var mEmployee = require('../models/modelEmployee');
var mProperty = require('../models/modelProperty');
var mMessage = require('../models/modelMessage');
var mCustomerFavorite = require('../models/modelCustomerFavorite');
var mSales = require('../models/modelSales');

var cookieConfigs = require('../../config/cookieConfigs');

var connection;

module.exports =
{
    setConnection: setConnection,
    renderDashboard: renderDashboard,
    removeListingAgent: removeListingAgent,
    addProperty: addProperty,
    uploadDP: uploadDP,
    saveDPToDB: saveDPToDB,
    editCustomer: editCustomer,
    editEmployee: editEmployee,

    getAgentMonthlySalesOfYear: getAgentMonthlySalesOfYear,

    getAgentMonthlySalesCountOfYear: getAgentMonthlySalesCountOfYear,
    getAgentYearWiseTotalSales: getAgentYearWiseTotalSales,
    uploadPropertyImage:uploadPropertyImage,
    getAgentYearWiseTotalSalesCount: getAgentYearWiseTotalSalesCount,
    predictPrice: predictPrice,
    addSales: addSales
};

function setConnection(conn)
{
    connection = conn;
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



function renderDashboard(req, res)
{
    var toastMessage;
	if(req.signedCookies['message'])
	{
		toastMessage= req.signedCookies['message'];
		res.clearCookie('message');
	}
    console.log("\n\nINSIDE RENDER DASHBOARD\n\n");
    if(req.signedCookies['customer'])
    {
        var id = req.signedCookies['customer'] / 15122017;
        console.log("\n\nCUSTOMER FOUND IN COOKIE: "+id+"\n\n");

        mCustomer.findById(function(err, customer)
        {
            if(err)
            {
                console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
            }

            mCustomerFavorite.findByCustomerId(function (error, results) {
                if (error) {
                    console.log('error[customer favorite]: ', error);
                }
                else
                {
                  mMessage.getCustMessage(function(err,messages)
                  {
                    console.log("\n\nInside getmessage \n\n");
                    if(err)
                    {
                      console.log("\n\nError sending the message\n\n");
                    }
                    else
                    {
                      console.log(JSON.stringify(messages));
                      res.render('DashboardCustomer', {
                          userProfile: customer,
                          properties: results ? results : [],
                          Messages: messages,
                          message: toastMessage
                      });                    }
                  },connection, customer.user);
                }
            }, connection, id);
        }, connection, id);
    }
    else if(req.signedCookies['company'])
    {
        var id = req.signedCookies['company'] / 15122017;
        console.log("\n\COMPANY ADMIN FOUND IN COOKIE: "+id+"\n\n");
        mEmployee.findById(function(err, companyadmin)
        {
            if(err)
            {
                console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
            }
            else
            {
                mType.findValuesByType(function(err, values)
                {
                    if(err)
                    {
                        console.log("\n\nERROR IN GETTING TYPES\n\n");
                    }
                    else
                    {
                        mEmployee.getEmployees(function(err, employees)
                        {
                            if(err)
                            {

                            }
                            else
                            {
                                res.render('DashboardCompanyAdmin', {userProfile: companyadmin, secQ: values, agents: employees, message: toastMessage});
                            }
                        }, connection, id);
                    }
                }, connection, 'SECURITY_QUES', null);
            }
        }, connection, id);
    }
    else if(req.signedCookies['employee'])
    {
      console.log("\n\nHERE\n\n");
      var id = req.signedCookies['employee'] / 15122017;
      mEmployee.findById(function(err, employee)
      {
          if(err)
          {
              console.log("\n\nERROR in FIND BY ID CALLBACK\n\n");
          }
          else
          {
            console.log("\n\n1\n\n");
            mProperty.getProperties(function(err, properties)
            {
                if(err)
                {
                    console.log(err);
                }
                else
                {
                    console.log("\n\n2\n\n");
                    mType.findValuesByType (function(err, values)
                    {
                        if(err)
                        {

                        }
                        else
                        {
                            console.log("\n\n3\n\n");
                            mMessage.getEmpMessage(function(err,messages)
                            {
                              if(err)
                              {
                                console.log("\n\nError sending the message\n\n");
                              }
                              else
                              {
                                console.log(JSON.stringify(messages));
mSales.getSalesByAgent(function (error, results) {
    if (error) {
         console.log('error[getSalesByAgent]: ', error);
            }

    res.render('DashboardListingAgent', {userProfile: employee, furS: values, myProperties: properties, Messages: messages, message: toastMessage, sales: results ? results : []});
}, connection, employee.employee);
                              }
                            },connection, employee.user);
                        }
                    }, connection, 'FURNISHING_STATE');
                }
            }, connection, id);
          }
      }, connection, id);
    }
    else
    {
        res.redirect('/');
    }
}

function removeListingAgent(req, res)
{
    console.log("REQ: "+JSON.stringify(req.body));
    if(req.signedCookies['company'])
    {
        mEmployee.removeByEmployeeId(function(err, result)
        {
            if(err)
            {
                res.status(520);
            }
            else
            {
                res.status(200).json({message: "Removed agent from database"});
            }
        }, connection, req.body.empID);
    }
}

function addProperty(req, res)
{
    if(req.signedCookies['employee'])
    {
        var id = req.signedCookies['employee'] / 15122017;
        mEmployee.findById(function(err, employee)
        {
            if(err)
            {

            }
            else
            {
                console.log(JSON.stringify(req.body));
                //var images = req.body.names.includes('?') ? req.body.names.split('?') : (req.body.names ? req.body.names : '');
                var property =
                {
                    employee: id,
                    title: req.body.title,
                    price: req.body.price,
                    overview: req.body.overview,
                    desc: req.body.desc,
                    size: req.body.size,
                    nor: req.body.numberofrooms,
                    furn: req.body.furnishingstate,
                    str: req.body.streetname,
                    hno: req.body.housenumber,
                    country: req.body.country,
                    state: req.body.state,
                    plz: req.body.plz,
                    city: req.body.city,
                    image1: req.body.names ? (req.body.names.includes('?') ? ("/img/property/"+req.body.names.split('?')[0]) : ("/img/property/"+req.body.names)) : '',
                    image2: req.body.names.includes('?') ? ("/img/property/"+req.body.names.split('?')[1]) : '',
                    image3: req.body.names.includes('?') ? ("/img/property/"+req.body.names.split('?')[2]) : ''
                };
                console.log(JSON.stringify(property));
                mProperty.addProperty(function(err, results)
                {
                    if(err)
                    {

                    }
                    else
                    {
                        mProperty.getProperties(function(err, properties)
                        {
                            res.send(properties);
                            console.log("\n\nIn GetEmployees\n\n");
                        }, connection, id);
                    }
                }, connection, property);
            }
        }, connection, id);
    }
}

function uploadDP(req, res)
{
  var storage = multer.diskStorage({
      destination: function (req, file, callback) {
        callback(null, 'Milestones/Milestone3/biig/public/img/users');
      },
      filename: function (req, file, callback) {
       callback(null, file.fieldname + "_" + Date.now()+ "_" + file.originalname);
     }
    });
    var upload = (multer({ storage: storage }).single('fileUser'));
    upload(req, res, function (err)
    {
        if (err) {
          console.log(JSON.stringify(err));
            return res.end("Something went wrong!");
        }
        return res.end(res.req.file.filename);
    });
}

function saveDPToDB(req, res)
{
    if(req.signedCookies['customer'])
    {
        var id = req.signedCookies['customer'] / 15122017;
        mCustomer.editDP(function(err, result)
        {
            if(err)
            {

            }
            else
            {
                res.sendStatus(200);
            }
        }, connection, {id: id, path: req.body.path});
    }
    else if(req.signedCookies['employee'])
    {
        var id = req.signedCookies['employee'] / 15122017;
        mEmployee.editDP(function(err, result)
        {
            if(err)
            {

            }
            else
            {
                res.sendStatus(200);
            }
        }, connection, {id: id, path: req.body.path});
    }
    else if(req.signedCookies['company'])
    {
        var id = req.signedCookies['company'] / 15122017;
        mEmployee.editDP(function(err, result)
        {
            if(err)
            {

            }
            else
            {
                res.sendStatus(200);
            }
        }, connection, {id: id, path: req.body.path});
    }
}

function uploadPropertyImage(req, res)
{
    var storage = multer.diskStorage({
      destination: function (req, file, callback) {
        callback(null, 'Milestones/Milestone3/biig/public/img/property');
      },
      filename: function (req, file, callback) {
       callback(null, file.fieldname + "_" + Date.now()+ "_" + file.originalname);
     }
    });
    var upload = (multer({ storage: storage }).fields([{ name: 'imgProperty1', maxCount: 1 }, { name: 'imgProperty2', maxCount: 1}, { name: 'imgProperty3', maxCount: 1}]));
    upload(req, res, function (err)
    {
        if (err) {
          console.log(JSON.stringify(err));
            return res.end("Something went wrong!");
        }
        var newFileName = "null"
        if(res.req.files["imgProperty1"])
          newFileName = res.req.files["imgProperty1"][0].filename;
        if(res.req.files["imgProperty2"])
          newFileName += "?"+res.req.files["imgProperty2"][0].filename;
        if(res.req.files["imgProperty3"])
          newFileName += "?"+res.req.files["imgProperty3"][0].filename;
        return res.end(newFileName);
    });
}

function editCustomer(req, res)
{
    console.log(JSON.stringify(req.body));

    var customer =
    {
        id: req.body.custid,
        firstname: req.body.firstname,
        lastname: req.body.lastname,
        email: req.body.email,
        phone: req.body.phone,
        street: req.body.streetname,
        hno: req.body.housenumber,
        country: req.body.country,
        state: req.body.state,
        plz: req.body.plz,
        city: req.body.city
    };

    mCustomer.editCustomer(function(err, result)
    {
        if(err)
        {

        }
        else
        {
            res.cookie('message', "Profile successfully edited", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
    }, connection, customer);
}

function editEmployee(req, res)
{
    console.log(JSON.stringify(req.body));
    var employee =
    {
        id: req.body.empid,
        firstname: req.body.firstname,
        lastname: req.body.lastname,
        email: req.body.email,
        phone: req.body.phone,
        street: req.body.streetname,
        hno: req.body.housenumber,
        country: req.body.country,
        state: req.body.state,
        plz: req.body.plz,
        city: req.body.city
    };
    console.log(JSON.stringify(employee));
    mEmployee.editEmployee(function(err, result)
    {
        if(err)
        {

        }
        else
        {
            res.cookie('message', "Profile Successfully Edited", cookieConfigs.short);
            res.redirect(req.header('Referer'));
        }
    }, connection, employee);
}

function getAgentMonthlySalesOfYear (req, res) {
    var emplpyeeId = req.params.id;
    var salesYear = req.params.year;

    // if sales year is invalid data then load monthly sales of current year
    if (!salesYear || 4 != salesYear.length || (4 == salesYear.length && 1000 > parseInt(salesYear))) {
        salesYear = new Date().getFullYear();
    }

    GetRequiredValues(req, res, function(user, message)
	{     mSales.getMonthlySalesOfYearByAgent(function (error, results) {
            if (error) {
         console.log('error[getMonthlySalesOfYearByAgent]: ', error);
            }

            var monthlySales = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

            results.forEach(function (result) {
                monthlySales[result.month_no - 1] = result.sale_amount;
            });

            var response = [
                        {
                            label: "Monthly Sales of Year: ".concat(salesYear),
                            fillColor: "rgba(220,220,220,0.2)",
                            strokeColor: "rgba(220,220,220,1)",
                            pointColor: "rgba(220,220,220,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(220,220,220,1)",
                            data: monthlySales
                        }
                    ];
        res.json(response);
        }, connection, emplpyeeId, salesYear);
    });
}

function getAgentMonthlySalesCountOfYear (req, res) {
    var emplpyeeId = req.params.id;
    var salesYear = req.params.year;

    // if sales year is invalid data then load monthly sales of current year
    if (!salesYear || 4 != salesYear.length || (4 == salesYear.length && 1000 > parseInt(salesYear))) {
        salesYear = new Date().getFullYear();
    }

    GetRequiredValues(req, res, function(user, message)
	{
        mSales.getMonthlySalesCountOfYearByAgent(function (error, results) {
            if (error) {
         console.log('error[getMonthlySalesCountOfYearByAgent]: ', error);
            }

            var monthlySalesCount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

            results.forEach(function (result) {
                monthlySalesCount[result.month_no - 1] = result.sale_count;
            });

            var response = [{
                        label: "Monthly Sales Count of Year: ".concat(salesYear),
                        data: monthlySalesCount,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)',
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)',
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1
                    }];

        res.json(response);
        }, connection, emplpyeeId, salesYear);
    });
}

function getAgentYearWiseTotalSales (req, res) {
    var emplpyeeId = req.params.id;

    GetRequiredValues(req, res, function(user, message)
	{
        mSales.getYearlySalesByAgent(function (error, results) {
            if (error) {
         console.log('error[getYearlySalesByAgent]: ', error);
            }

            var backgroundColor = ["#F7464A", "#46BFBD", "#FDB45C", "#949FB1", "#4D5360"];

            var hoverBackgroundColor =  ["#FF5A5E", "#5AD3D1", "#FFC870", "#A8B3C5", "#616774"];

            var salesYears = [];
            var sales = [];
            var bgColors = [];
            var hoverBgColors = [];

            results.forEach(function (result, index) {
                salesYears.push(result.year_no);
                sales.push(result.sale_amount);
                bgColors.push(backgroundColor[index]);
                hoverBgColors.push(hoverBackgroundColor[index]);
            });

            var response = {
                years: salesYears,
                sales: [
                {
                    data: sales,
                    backgroundColor: bgColors,
                    hoverBackgroundColor: hoverBgColors
                }
            ]
        };

        res.json(response);
        }, connection, emplpyeeId);
    });
}

function getAgentYearWiseTotalSalesCount (req, res) {
    var emplpyeeId = req.params.id;

    GetRequiredValues(req, res, function(user, message)
	{
        mSales.getYearlySalesCountByAgent(function (error, results) {
            if (error) {
         console.log('error[getYearlySalesCountByAgent]: ', error);
            }

            var backgroundColor = ["#F7464A", "#46BFBD", "#FDB45C", "#949FB1", "#4D5360"];

            var hoverBackgroundColor =  ["#FF5A5E", "#5AD3D1", "#FFC870", "#A8B3C5", "#616774"];

            var salesYears = [];
            var sales = [];
            var bgColors = [];
            var hoverBgColors = [];

            results.forEach(function (result, index) {
                salesYears.push(result.year_no);
                sales.push(result.sale_count);
                bgColors.push(backgroundColor[index]);
                hoverBgColors.push(hoverBackgroundColor[index]);
            });

            var response = {
                years: salesYears,
                salesCount: [
                {
                    data: sales,
                    backgroundColor: bgColors,
                    hoverBackgroundColor: hoverBgColors
                }
            ]
        };

        res.json(response);
        }, connection, emplpyeeId);
    });
}

function addSales(req, res)
{
    if(req.signedCookies['employee'])
    {
        console.log(JSON.stringify(req.body));
        var id = req.signedCookies['employee'] / 15122017;
        var sale =
        {
            emp: id,
            prop: req.body.propertyid,
            price: req.body.price,
            date: req.body.saledate,
            name: req.body.firstname + req.body.lastname,
            email: req.body.email,
        }
        mSales.addSales(function(err, result)
        {
            if(err)
            {

            }
            else
            {
                res.cookie('message', 'Sale added successfully');
                res.redirect(req.header('Referer'));
            }
        },connection, sale);
    }
}
function predictPrice(){
  console.log("In controller");
  //import csvToMatrix  from 'csv-to-array-matrix';

  //csvToMatrix('./views/Pricesizerooms.csv', init);

  function init(matrix) {

    // Part 0: Preparation
    console.log('Part 0: Preparation ...\n');

      let X = Math.eval('matrix[:, 1:2]', {
        matrix,
      });
      let y = Math.eval('matrix[:, 3]', {
        matrix,
      });

      let m = y.length;

  // Part 1: Normal Equation
    console.log('Part 1: Normal Equation ...\n');

  // Add Intercept Term
    X = Math.concat(Math.ones([m, 1]).valueOf(), X);

    let theta = normalEquation(X, y);

    console.log('theta: ', theta);
    console.log('\n');

  // Part 2: Predict Price of 1650 square meter and 3 bedroom house
    console.log('Part 3: Price Prediction ...\n');

    let houseVector = [1, 1650, 3];
    let price = Math.eval('houseVector * theta', {
      houseVector,
      theta,
    });

    console.log('Predicted price for a 1650 square meter and 3 bedroom house: ', price);
}

function normalEquation(X, y) {
  let theta = Math.eval(`inv(X' * X) * X' * y`, {
    X,
    y,
  });

  return theta;
}
}
