-- the following query is for property details


SELECT     prop.id,
        typeofprop.value typeofproperty,
        usge.value `usage`,
        prop.title,
        addr.housenumber,
       addr.street,
        addr.plz,
        city.`value` city,
       state.`value` state,
        country.`value` country,
       prop.image1,
        prop.image2,
        prop.image3,
        prop.size,
        prop.numberofrooms,
        furstat.value furnishingstate

FROM property prop,
     address addr,
     typevalue typeofprop,
    typevalue usge,
    typevalue furstat,
    typevalue city,
    typevalue state,
    typevalue country

WHERE prop.address = addr.id
AND prop.typeofproperty = typeofprop.id
AND prop.`usage` = usge.id
AND prop.furnishingstate = furstat.id
AND addr.city = city.id
AND addr.state = state.id
AND addr.country = country.id;


-- this query is also be used in property finder by adding filter parameters

SELECT 	prop.id,
		typeofprop.`value` typeofproperty,
		usge.`value` `usage`,
		prop.title,
		addr.housenumber,
        addr.street,
		addr.plz,
		city.`value` city,
        state.`value` state,
		country.`value` country,
        prop.image1,
		prop.image2,
		prop.image3,
		prop.size,
		prop.numberofrooms,
		furstat.`value` furnishingstate
        
FROM property prop, 
	 address addr, 
	 typevalue typeofprop,
     typevalue usge,
     typevalue furstat,
     typevalue city,
     typevalue state,
     typevalue country

WHERE prop.address = addr.id
AND prop.typeofproperty = typeofprop.id
AND prop.`usage` = usge.id
AND prop.furnishingstate = furstat.id 
AND addr.city = city.id
AND addr.state = state.id
AND addr.country = country.id
AND CONCAT_WS(' ', LOWER(addr.housenumber), LOWER(addr.street), addr.plz, LOWER(city.`value`))
	LIKE '%berlin%';