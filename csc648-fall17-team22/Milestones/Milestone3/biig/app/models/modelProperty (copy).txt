/*
File Name: modelProperty.js

Description:
This is a property model which communicates with database server
to perform CRUD(Create, Read, Update, Delete) operations. After
getting results from database server, it processes results and finally
send a response to controller as per controller's need.

Authors:
Mahbubur Rahman, Swetaketu Majumder, Akhila
*/

module.exports =
{
    search: search,
    findById: findById,
    getPropertyFilters: getPropertyFilters,
    addProperty: addProperty,
    getProperties: getProperties,
    getAllProperties:getAllProperties
};

var propLightSql = "SELECT prop.id, prop.price, prop.numberofrooms, prop.title, prop.size, addr.housenumber, addr.street, addr.plz, addr.city, addr.state, addr.country, prop.image1, prop.yearbuilt, DATE_FORMAT(prop.posted, '%c/%e/%Y %T') posted ";

var propLightFromSql = "FROM address addr,property prop ";

var propLightWhereSql = "WHERE prop.address = addr.id ";

var propDetailSql = "SELECT emp.user, prop.id, prop.price, prop.overview, prop.description, typeofprop.`value` typeofproperty, usge.`value` `usage`, "+
        "prop.title, addr.housenumber, addr.street, addr.plz, addr.city, addr.state, "+
        "addr.country, prop.image1, prop.image2, prop.image3, prop.size, prop.numberofrooms, "+
        "furstat.`value` furnishingstate, prop.yearbuilt, DATE_FORMAT(prop.posted, '%c/%e/%Y %T') posted, CONCAT_WS(' ', emp.firstname, emp.lastname) agent_name, emp.profilepicture agent_image, emp.phonenumber agent_phone, "+
        "comp.name agent_company, desig.`value` agent_designation "+
        "FROM property prop, address addr, typevalue typeofprop, typevalue usge, typevalue furstat, "+
        "employee emp, typevalue desig, company comp "+
        "WHERE prop.address = addr.id AND prop.typeofproperty = typeofprop.id "+
        "AND prop.`usage` = usge.id AND prop.furnishingstate = furstat.id "+
        "AND prop.employee = emp.id "+
        "AND emp.company = comp.id "+
        "AND emp.designation = desig.id ";

function convertValueToArray (value) {
    var arr = [];

    if (typeof value === 'string') {
        arr.push(value);
    } else if (typeof value === 'object' && 0 < value.length) {
        value.forEach(function (v) {
            arr.push(v);
        });
    }

    return arr;
}

function splitKeysAndAddRegex (key) {
    // replace all non alpha numeric chars with spaces
    key = key.replace(/[^a-zA-Z0-9]/g, ' ');

    var keys = key.trim().split(' ');

    var strKey = '';

    keys.forEach(function (key) {
        key = key.trim();

        if (key && 0 < key.length ) {
            strKey = strKey.concat('%', key,  '%');
        }
    });

    strKey = strKey.toLowerCase();

    return strKey;
}

function addFreeTextFilter (key) {
    if (!key) {
        return "";
    }

    return " AND ( CONCAT_WS(' ', LOWER(addr.housenumber), LOWER(addr.street), addr.plz, LOWER(addr.city)) LIKE '".concat(splitKeysAndAddRegex(key), "' ");
}

function addLocationFilter (location, key) {
    if (!location && !key) {
        return "";
    }

    if (!location) {
        return " ) ";
    }

    var locations = convertValueToArray(location);

    var locationSql = " addr.city IN ( ";

    locations.forEach(function (city, index) {
        locationSql = locationSql.concat(0 == index ? "" : ", ", "'", city, "'");
    });

     locationSql = locationSql.concat(" )  ");

    if (!key) {
        return " AND ".concat(locationSql);
    }

    return " OR ".concat(locationSql, " ) ");
}

function makeSqlForSize (size) {
    if (!size.includes('-')) {
        return " prop.size ".concat(size, " ");
    }

    var sizeArr = size.split('-');

    return " ( prop.size >= ".concat( sizeArr[0].trim(), " AND prop.size < ", sizeArr[1].trim(), " ) ");
}

function addSizeFilter (size) {
    if (!size) {
        return "";
    }

    var sizes = convertValueToArray(size);

    var sizeSql = " AND ";

    if (1 == sizes.length) {
        return sizeSql.concat(makeSqlForSize(sizes[0]));
    }

    sizeSql = sizeSql.concat(" ( " , makeSqlForSize(sizes[0]));

    for (var i = 1; i < sizes.length; i++) {
        sizeSql = sizeSql.concat(" OR ", makeSqlForSize(sizes[i]));
    }

    return sizeSql.concat(" ) ");
}

function addFurnishingStateFilter (furnishingState) {
    if (!furnishingState) {
        return "";
    }

    return " AND prop.furnishingstate IN ( ".concat(convertValueToArray(furnishingState).join(','), " )  ");
}

function addNumberOfRoomsFilter (numberOfRooms) {
    if (!numberOfRooms) {
        return "";
    }

    var numberOfRoomsArr = convertValueToArray(numberOfRooms);

    numOfRoomsSql = " AND ";

    var numWithOptrIndex = numberOfRoomsArr.findIndex(function (counter) {
        return counter.includes(">=");
    });

    var numWithOptrArr = [];

    if (-1 != numWithOptrIndex) {
        numWithOptrArr = numberOfRoomsArr.splice(numWithOptrIndex, 1);
    }

    if (0 < numWithOptrArr.length && 0 < numberOfRoomsArr.length) {
        return numOfRoomsSql.concat(" ( prop.numberofrooms IN ( ", numberOfRoomsArr.join(','), " ) OR prop.numberofrooms ", numWithOptrArr[0], " ) ");
    }

    if (0 < numWithOptrArr.length) {
        return numOfRoomsSql.concat(" prop.numberofrooms ", numWithOptrArr[0]);
    }

    return numOfRoomsSql.concat(" prop.numberofrooms IN ( ", numberOfRoomsArr.join(','), " ) ");
}

function addSorting(sort) {
    if (!sort) {
        sort = 'Newest First';
    }

    sortSql = " ORDER BY ";

    sort = sort.trim().toLowerCase();

        switch(sort) {
                case 'Newest First'.toLowerCase(): sortSql = sortSql.concat(" prop.posted DESC ");
                    break;

                case 'Price: High to Low'.toLowerCase(): sortSql = sortSql.concat(" prop.price DESC ");
                    break;

                case 'Price: Low to High'.toLowerCase(): sortSql = sortSql.concat(" prop.price ASC ");
                    break;

                case 'Age: New to Old'.toLowerCase(): sortSql = sortSql.concat(" prop.yearbuilt DESC ");
                    break;

                case 'Age: Old to New'.toLowerCase(): sortSql = sortSql.concat(" prop.yearbuilt ASC ");
                    break;
        }

    return sortSql;
}

function generateSearchSql (searchOptions, customerId) {

    return propLightSql.concat(

        customerId ? " , IF (cust_fav.property IS NULL, 0, 1) customer_favorite " : "",

        propLightFromSql,

        customerId ? " LEFT JOIN customer_favorites cust_fav ON ( prop.id = cust_fav.property AND cust_fav.customer = ".concat(customerId, " ) ") : "",

        propLightWhereSql,

        addFreeTextFilter(searchOptions.key),

        addLocationFilter(searchOptions.location, searchOptions.key),

        addSizeFilter(searchOptions.size),

        addFurnishingStateFilter(searchOptions.furnishingState),

        addNumberOfRoomsFilter(searchOptions.numberOfRooms),

        addSorting(searchOptions.sort)
    );
}

function search(callback, connection, searchOptions, customerId)
{
    process.nextTick(function ()
    {
        var propSql = generateSearchSql(searchOptions, customerId);

        connection.query(propSql, function(error, results)
        {
            if (error)
            {
                return callback(error);
            }

            callback(null, results);
        });
    });
}

function findById (callback, connection, id)
{
    process.nextTick (function ()
    {
        var propSql = propDetailSql + " AND prop.id = " + id;

        connection.query(propSql, function (error, results) {
            if (error)
            {
                return callback(error);
            }

            callback(null, results[0]);
        });
    });
}

function getPropertyFilters (callback, connection, fetchLocations, fetchSortOptions) {
    process.nextTick(function ()
    {
        var propSql = "CALL get_property_filters(" + fetchLocations + ", " + fetchSortOptions + ")";

                connection.query(propSql, function (error, results) {
                    if (error)
                    {
                        return callback(error);
                    }

                    callback(null, results);
                });
    });
}

function addProperty(callback, connection, property)
{
    console.log("IN ADD PROPERTY");
    process.nextTick(function()
    {
        var createProp = "CALL create_property('"+property.title+"', "+property.size+", "+property.nor+", "+
                        property.furn+", "+property.price+", 2017, "+property.employee+", now(), '"+property.overview+"', '"+
                        property.desc+"', '"+property.city+"', '"+property.str+"', '"+property.hno+"', "+
                        property.plz+", '"+property.state+"', '"+property.country+"', '"+property.image1+"', '"+property.image2+"', '"+property.image3+"')";
        console.log(createProp);
                        connection.query(createProp, function (error, results) {
                            if (error)
                            {
                                console.log('error in executing sql: ', error);
                                return callback(error);
                            }

                            callback(null, results);
                        });

    });
}

function getProperties(callback, connection, empId)
{
    process.nextTick(function()
    {
        var propSql = propLightSql.concat(

            propLightFromSql,

            propLightWhereSql,

            " AND prop.employee = ",

            empId
        );

        connection.query(propSql, function(err, results)
        {
            if(err)
            {
                console.log("ERROR");
            }
            else
            {
                callback(null, results);
            }
        });
    });
}

function getAllProperties(callback, connection)
{
    process.nextTick(function()
    {
        var sortSqlHere = " ORDER BY prop.posted ";
        var propSql = propLightSql.concat(

            propLightFromSql,

            propLightWhereSql,

            sortSqlHere
        );

        connection.query(propSql, function(err, results)
        {
            if(err)
            {
                console.log("ERROR");
            }
            else
            {
                callback(null, results);
            }
        });
    });
}
