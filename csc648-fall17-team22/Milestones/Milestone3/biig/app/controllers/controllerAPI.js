const fs = require('fs');

var bcrypt = require('bcrypt-nodejs');
var mUser = require('../models/modelUser');
var mProperty = require('../models/modelProperty');
var mCustomer = require('../models/modelCustomer');
var mType = require('../models/modelType');
var mRPi = require('../models/modelRPi');

var connection;

module.exports =
{
	setConnection: setConnection,
	authenticateUser: authenticateUser,
    searchproperty: searchproperty,
    usersignup: usersignup,
    getTypeValues: getTypeValues,
    uploadImage: uploadImage,
    getPropertyFilterOptions: getPropertyFilterOptions,
    getProperties: getProperties,
    getProperty: getProperty,
    addProperty: addProperty,
    getRpiIP: getRpiIP
};

function setConnection(conn)
{
	connection = conn;
}

function getRpiIP(req, res)
{
    console.log("inside getRpiIP");
    mRPi.getIP(connection, function(err, results)
    {
        if(err)
        {
            res.status(200).json(false);
        }
        else
        {
            res.status(200).json(results);
        }
    });
}

function authenticateUser(req, res){
  console.log("inside authenticateUser: params: " + req.body.username)
  var username = req.body.username;
  var password = req.body.password;

  mUser.findByEmail(connection, req.body.username, function(err, user)
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
          if(bcrypt.compareSync(req.body.password, user.password))
          {
             res.send(user);
          }
          else
          {
             res.send(false);
          }
      }
  });

/*  var propSql = "SELECT * FROM user where email = '"+ username +"'";
  console.log(propSql);
  connection.query(propSql, function(error, results)
  {
      if (error)
      {
        var sentResults={
          success:false,
          data:error
        }
        res.send(sentResults);
        return;
      }

      var sentResults={
        success:true,
        data:results
      }
      res.send(sentResults);
  });*/


}

function searchproperty(req, res){
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
//        var sentResults={
//          properties:results
//        }
//        res.send(sentResults);
          res.status(200).json(results);
    }, connection, searchOptions, null);

}

function usersignup(req,res)
{
  var customer =
  {
      firstname: req.body.firstname,
      lastname: req.body.lastname,
      email: req.body.email,
      password: bcrypt.hashSync(req.body.password),
      securityQuestion: req.body.securityQuestion,
      securityAnswer: bcrypt.hashSync(req.body.securityAnswer)
  };

  console.log(customer);

  mCustomer.addCustomer(function(err, custID, message)
  {
      if(err)
      {
        res.status(200).json(false);
      }
      else
      {
          res.status(200).json(true);
      }
  }, connection, customer);
}

// e.g: security questions, furnishing states etc...
function getTypeValues(req, res) {

    mType.findValuesByType(function(error, values) {
        
        if(error) {
            
            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
        }
        
        res.status(200).json(values);
        
    }, connection, req.params.typeName, null);
}


function uploadImage(req, res) {
    
    var imageType = req.body.imageType.toLowerCase(); // e.g: property, user
    var imageName = req.body.imageName; // e.g: <image name>-<current timestamp>-<image no>.png
    var imageData = req.body.imageData; // base64 string
    
    // public/img/
    var imagePath = "Milestones/Milestone3/biig/public/img/".concat(imageType, "/", imageName);
    
    fs.writeFile(imagePath, imageData, "base64", (error) => {

        if (error) {
            
            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
        }

        res.status(200).json({ message: imageName.concat(" image data saved into file.") });
    });
}

function getPropertyFilters (callback) {
    
    process.nextTick (function () {
        mProperty.getPropertyFilters(callback, connection, 1, 1);
    });
}

function getPropertyFilterOptions(req, res) {

    getPropertyFilters(function (error, results) {
        
        if (error) {
            
            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
        }

        var filterOptions = {
            
            locations: results[0] ? results[0] : [],
            sizes: results[1] ? results[1] : [],
            furnishingStates: results[2] ? results[2] : [],
            sortOptions: results[3] ? results[3] : []
            
        };
        
        res.status(200).json(filterOptions);
    });
}

function getProperties(req, res) {
    
    mProperty.getProperties(function(error, properties) {
        
        if (error) {
            
            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
        }
        
        res.status(200).json(properties);
    
    }, connection, req.params.id);
}

function getProperty(req, res) {
    
    mProperty.findById(function(error, result) {
       
       if (error) {
           
            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
       }
          
       res.status(200).json(result ? result : {});
                       
    }, connection, req.params.id);
}

function uploadPropertyImage(imageName, imageData) {
    
    // public/img/property/
    var imagePath = "Milestones/Milestone3/biig/public/img/property/".concat(imageName);
    
    fs.writeFile(imagePath, imageData, "base64", (error) => {

        if (error) {
            
            console.log(error);
            return;
        }

        console.log(imageName.concat(" image data saved into file."));
    });
    
    return imageName;
}

function doSumUTF8Values(str) {
    
    var i, sum = 0;
    
    for (i = 0; i < str.length; i++) {
        
        sum += str.charCodeAt(i)
    };
    
    return sum;
}

function makePropertyFromRequest(req) {

    var intTitle = doSumUTF8Values(req.body.title) + parseInt(Math.random() * 1000); 
    var imageName = "".concat(intTitle, '-', new Date().getTime(), '-image-#.$');
    
    var property = {
        employee : req.body.employeeId,
        title : req.body.title,
        price : req.body.price,
        overview : req.body.overview,
        desc : req.body.desc,
        size : req.body.size,
        nor : req.body.numberofrooms,
        furn : req.body.furnishingstate,
        str : req.body.streetname,
        hno : req.body.housenumber,
        country : req.body.country,
        state : req.body.state,
        plz : req.body.plz,
        city : req.body.city,
        // img/property/
        image1 : req.body.image1 ? "fa17g22/img/property/".concat(uploadPropertyImage(imageName.replace('#', 1).replace('$', req.body.image1Format), req.body.image1)) : '',
        image2 : req.body.image2 ? "fa17g22/img/property/".concat(uploadPropertyImage(imageName.replace('#', 2).replace('$', req.body.image2Format), req.body.image2)) : '',
        image3 : req.body.image3 ? "fa17g22/img/property/".concat(uploadPropertyImage(imageName.replace('#', 3).replace('$', req.body.image3Format), req.body.image3)) : ''
    };
    
    return property;
}

function addProperty(req, res) {

    var property = makePropertyFromRequest(req);
    
    mProperty.addProperty(function(error, result) {

        if(error) {

            console.log(error);
            res.status(500).json({ error: "Please check server log for details." });
            return;
        }

        res.status(200).json({ id: result[0][0]["last_insert_id()"] });

    }, connection, property);
}
