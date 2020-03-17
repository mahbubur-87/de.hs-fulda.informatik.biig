-- 1st level query to get value list of any type like security question, gender, designation, property type, property usage etc.

SELECT tv.id, tv.value
FROM typevalue tv, `type` t
WHERE tv.parenttype = t.id
AND LOWER(t.name) = LOWER('DESIGNATION');

-- 2nd level query to get value list of any type and its parent type

SELECT tv.id, tv.value
FROM typevalue tv, `type` t, typevalue parent_tv
WHERE tv.parenttype = t.id
AND tv.parenttypevalue = parent_tv.id
AND LOWER(t.name) = LOWER('CITY')
AND LOWER(parent_tv.value) = LOWER('Hesse');

SELECT tv.id, tv.value
FROM typevalue tv, `type` t, typevalue parent_tv
WHERE tv.parenttype = t.id
AND tv.parenttypevalue = parent_tv.id
AND LOWER(t.name) = LOWER('STATE')
AND LOWER(parent_tv.value) = LOWER('Germany');

-- 3rd level query to get value list of any type and its grand parent type

SELECT tv.id, tv.value
FROM typevalue tv, 
	 `type` t, 
	 typevalue parent_tv,
	 typevalue grand_parent_tv
WHERE tv.parenttype = t.id
AND tv.parenttypevalue = parent_tv.id
AND parent_tv.parenttypevalue = grand_parent_tv.id
AND LOWER(t.name) = LOWER('CITY')
AND LOWER(grand_parent_tv.value) = LOWER('Germany');
