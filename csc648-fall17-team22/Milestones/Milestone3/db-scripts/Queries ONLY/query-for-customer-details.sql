SELECT 	cust.id,
		cust.profilepicture,
		cust.firstname,
		cust.lastname,
		cust.phonenumber,
		usr.email,
        addr.housenumber,
		addr.street,
        addr.plz,
        city.`value` city,
		state.`value` state,
        country.`value` country,
		usr.username,
        usr.`password`,
        rle.rolename,
        secques.`value` securityquestion,
        usr.securityanswer		
FROM customer cust, 
	 address addr, 
     user usr,
     role rle,
     typevalue city,
     typevalue state,
     typevalue country,
     typevalue secques
WHERE cust.address = addr.id
AND cust.`user` = usr.id
AND usr.role = rle.id
AND addr.city = city.id
AND addr.state = state.id
AND addr.country = country.id
AND usr.securityquestion = secques.id    
-- AND cust.id = ?