module.exports ={
  saveFeedbacks : saveFeedbacks
};



function saveFeedbacks(name,email,message,connection,callback){
  var query = " INSERT INTO feedback ( name, email,message ) VALUES ( '"+name+"', '"+email+"', '"+message+"' );";
  connection.query(query,function(er,res) {
     if(er)
     {
       callback("Failed");
     }
      else
      {
        callback("Success");
      }
  });
}
