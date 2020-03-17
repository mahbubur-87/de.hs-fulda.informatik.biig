/*
File Name: modelCustomerFavorite.js

Description:
This is a customer favorite model which communicates with database server
to perform CRUD(Create, Read, Update, Delete) operations. After
getting results from database server, it processes results and finally
send a response to controller as per controller's need.

Authors:
Mahbubur Rahman
*/

module.exports = {
    findByCustomerId: findByCustomerId,
    addToFavorite: addToFavorite,
    removeFromFavorite: removeFromFavorite
};

function findByCustomerId (callback, connection, customerId) {
    process.nextTick (function ()
    {
        var favSql = "SELECT DISTINCT prop.id, prop.price, "+
		"prop.title, addr.housenumber, addr.street, addr.plz, addr.city, addr.state, addr.country, prop.image1, prop.yearbuilt, prop.posted "+
        "FROM customer_favorites cf, property prop, address addr "+
        "WHERE cf.property = prop.id " +
        "AND prop.address = addr.id "+
        "AND cf.customer = " + customerId;

        connection.query(favSql, function (error, results) {
            if (error)
            {
                return callback(error);
            }

            callback(null, results);
        });
    });
}

function addToFavorite (callback, connection, customerId, propertyId) {
    process.nextTick (function ()
    {
        var favSql = "INSERT INTO customer_favorites(customer, property) VALUES(" + customerId + ", " + propertyId + ")";
        var favSqlSelect = "SELECT DISTINCT prop.id, prop.price, prop.numberofrooms,prop.furnishingstate,"+
		"prop.title, addr.housenumber, addr.street, addr.plz, addr.city, addr.state, addr.country, prop.image1, prop.yearbuilt, prop.posted "+
        "FROM customer_favorites cf, property prop, address addr "+
        "WHERE cf.property = prop.id " +
        "AND prop.address = addr.id "+
        "AND cf.customer = " + customerId;
        connection.query(favSql, function (error, results) {
            if (error) {
                return callback(error);
            }

            connection.query(favSqlSelect, function (error, results) {
                if (error) {
                    return callback(error);
                }

                callback(null, results);
            });
        });
    });
}

function removeFromFavorite (callback, connection, customerId, propertyId) {
    process.nextTick (function ()
    {
        var favSql = "DELETE FROM customer_favorites WHERE customer = " + customerId + " AND property = " + propertyId;
        var favSqlSelect = "SELECT DISTINCT prop.id, prop.price,prop.numberofrooms,prop.furnishingstate, "+
		"prop.title, addr.housenumber, addr.street, addr.plz, addr.city, addr.state, addr.country, prop.image1, prop.yearbuilt, prop.posted "+
        "FROM customer_favorites cf, property prop, address addr "+
        "WHERE cf.property = prop.id " +
        "AND prop.address = addr.id "+
        "AND cf.customer = " + customerId;
        connection.query(favSql, function (error, results) {
            if (error)
            {
                return callback(error);
            }

            connection.query(favSqlSelect, function (error, results) {
                if (error) {
                    return callback(error);
                }

                callback(null, results);
            });
        });
    });
}
