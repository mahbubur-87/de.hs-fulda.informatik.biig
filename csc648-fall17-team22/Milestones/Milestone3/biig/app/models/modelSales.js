/*
File Name: modelSales.js

Description:
This is a sales model which communicates with database server 
to perform CRUD(Create, Read, Update, Delete) operations. After 
getting results from database server, it processes results and finally
send a response to controller as per controller's need. 

Authors:
Mahbubur Rahman, Swetaketu Majumder
*/

module.exports =
{
    addSales: addSales,
    getSalesByAgent: getSalesByAgent,
    
    getMonthlySalesOfYearByAgent: getMonthlySalesOfYearByAgent,
    
    getMonthlySalesCountOfYearByAgent: getMonthlySalesCountOfYearByAgent,
    
    getYearlySalesByAgent: getYearlySalesByAgent,
    
    getYearlySalesCountByAgent: getYearlySalesCountByAgent    
};

var monthlySalesSql = "SELECT MONTH(s.saletime) month_no ";

var monthlySalesFromSql = " FROM sale s ";

var monthlySalesWhereSql = " WHERE ";

var monthlySalesGroupBySql = " GROUP BY MONTH(s.saletime) ORDER BY MONTH(s.saletime) ";

var yearlySalesSql = "SELECT 	YEAR(s.saletime) year_no ";

var yearlySalesFromSql = " FROM sale s ";

var yearlySalesWhereSql = " WHERE ";

var yearlySalesGroupBySql = " GROUP BY YEAR(s.saletime) ORDER BY YEAR(s.saletime) DESC LIMIT 5 ";

function addSales(callback, connection, sale)
{
    process.nextTick(function()
    {
        var salesSql = "CALL create_sale ("+sale.emp+", '"+sale.name+"', '"+sale.email+"', "+sale.price+", '"+sale.date+"', "+sale.prop+")";
        console.log(salesSql);
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}

function getSalesByAgent(callback, connection, employeeId)
{
    process.nextTick(function()
    {
        var salesSql = "SELECT DATE_FORMAT(s.saletime, '%c/%e/%Y %T') saletime, s.property_title, s.property_address, s.customer_name, s.customer_email, s.price FROM sale s WHERE s.employee = ".concat(employeeId);
        
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}

function getMonthlySalesOfYearByAgent(callback, connection, emplpyeeId, salesYear)
{
    process.nextTick(function()
    {
        var salesSql = monthlySalesSql.concat(
            
            ", SUM(s.price) sale_amount ",
            
            monthlySalesFromSql,
            
            monthlySalesWhereSql,
            
            " s.employee = ",
            
            emplpyeeId,
            
            " AND YEAR(s.saletime) = ",
            
            salesYear,
            
            monthlySalesGroupBySql

        );
        
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}

function getMonthlySalesCountOfYearByAgent(callback, connection, emplpyeeId, salesYear)
{
    process.nextTick(function()
    {
        var salesSql = monthlySalesSql.concat(
            
            ", COUNT(s.property_title) sale_count ",
            
            monthlySalesFromSql,
            
            monthlySalesWhereSql,
            
            " s.employee = ",
            
            emplpyeeId,
            
            " AND YEAR(s.saletime) = ",
            
            salesYear,
            
            monthlySalesGroupBySql

        );
        
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}

function getYearlySalesByAgent(callback, connection, emplpyeeId)
{
    process.nextTick(function()
    {
        var salesSql = yearlySalesSql.concat(
            
            ", SUM(s.price) sale_amount ",
            
            yearlySalesFromSql,
            
            yearlySalesWhereSql,
            
            " s.employee = ",
            
            emplpyeeId,
            
            yearlySalesGroupBySql

        );
        
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}

function getYearlySalesCountByAgent(callback, connection, emplpyeeId)
{
    process.nextTick(function()
    {
        var salesSql = yearlySalesSql.concat(
            
            ", COUNT(s.property_title) sale_count ",
            
            yearlySalesFromSql,
            
            yearlySalesWhereSql,
            
            " s.employee = ",
            
            emplpyeeId,
            
            yearlySalesGroupBySql

        );
        
        connection.query(salesSql, function(error, results)
        {
            if(error) {
                callback(error);    
            }
            
            callback(null, results);
        });
    });
}