module.exports = 
{
    getIP: getIP
}

function getIP(connection, callback)
{
    connection.query("select * from rpi", function(err, results)
    {
        if(err)
        {
            callback(err);
        }
        else
        {
            callback(null, results);
        }
    });
}