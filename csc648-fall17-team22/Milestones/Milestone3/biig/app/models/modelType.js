/*
File Name: modelType.js

Description:
This is a type model which communicates with database server 
to perform read operation. After getting results from database 
server, it processes results and finally send a response to 
controller as per controller's need. 

Authors:
Mahbubur Rahman
*/

module.exports = 
{
    findValuesByType: findValuesByType,
}

function findValuesByType (callback, connection, type, parentValue) 
{
    process.nextTick(function () 
    {    
        var valSql = parentValue ? 
                    ("SELECT tv.id, tv.value " + 
                    "FROM typevalue tv, `type` t, typevalue parent_tv " + 
                    "WHERE tv.parenttype = t.id " + 
                    "AND tv.parenttypevalue = parent_tv.id " + 
                    "AND t.name = '" + type + "' " + 
                    "AND lower(parent_tv.value) = lower('" + parentValue + "')") 
                    : 
                    ("SELECT tv.id, tv.value " +  
                    "FROM typevalue tv, `type` t " +
                    "WHERE tv.parenttype = t.id " +
                    "AND t.name = '" + type + "'");
        
        connection.query(valSql, function (error, results) 
        {
            if (error) 
            {
                console.log('error in executing sql: ', error);
                return callback(error);
            }
            callback(null, results);
        });
    });
}