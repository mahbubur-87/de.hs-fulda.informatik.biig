SELECT YEAR(NOW());


SELECT 	MONTH(s.saletime) month_no,
		MONTHNAME(s.saletime) month_name,
		SUM(s.price) sale_amount,
        COUNT(s.property_title) sale_count
FROM sale s
WHERE s.employee = 2
AND YEAR(s.saletime) = 2017
GROUP BY MONTH(s.saletime)
ORDER BY MONTH(s.saletime);

-- last 5 years total sales and sales count
SELECT 	YEAR(s.saletime) year_no,
		SUM(s.price) sale_amount,
        COUNT(s.property_title) sale_count
FROM sale s
WHERE s.employee = 2
GROUP BY YEAR(s.saletime)
ORDER BY YEAR(s.saletime) DESC
LIMIT 5;
