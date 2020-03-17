-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema heroku_e95df90031946ad
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `heroku_e95df90031946ad` ;

-- -----------------------------------------------------
-- Schema heroku_e95df90031946ad
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `heroku_e95df90031946ad` DEFAULT CHARACTER SET latin1 ;
USE `heroku_e95df90031946ad` ;

-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`address` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(80) NOT NULL,
  `street` VARCHAR(255) NOT NULL,
  `housenumber` VARCHAR(100) NOT NULL,
  `plz` INT(16) NOT NULL,
  `state` VARCHAR(50) NOT NULL,
  `country` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`company` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`role` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `rolename` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `parenttype` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_type__parenttype` (`parenttype` ASC),
  CONSTRAINT `fk_type__parenttype`
    FOREIGN KEY (`parenttype`)
    REFERENCES `heroku_e95df90031946ad`.`type` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`typevalue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`typevalue` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(255) NOT NULL,
  `parenttype` INT(11) NOT NULL,
  `parenttypevalue` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_typevalue__parenttype` (`parenttype` ASC),
  INDEX `idx_typevalue__parenttypevalue` (`parenttypevalue` ASC),
  CONSTRAINT `fk_typevalue__parenttype`
    FOREIGN KEY (`parenttype`)
    REFERENCES `heroku_e95df90031946ad`.`type` (`id`),
  CONSTRAINT `fk_typevalue__parenttypevalue`
    FOREIGN KEY (`parenttypevalue`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `securityquestion` INT(11) NULL DEFAULT NULL,
  `role` INT(11) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` LONGTEXT NULL DEFAULT NULL,
  `securityanswer` LONGTEXT NULL DEFAULT NULL,
  `customer` INT(11) NULL DEFAULT NULL,
  `employee` INT(11) NULL DEFAULT NULL,
  `companyadmin` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_user__role` (`role` ASC),
  INDEX `idx_user__securityquestion` (`securityquestion` ASC),
  CONSTRAINT `fk_user__role`
    FOREIGN KEY (`role`)
    REFERENCES `heroku_e95df90031946ad`.`role` (`id`),
  CONSTRAINT `fk_user__securityquestion`
    FOREIGN KEY (`securityquestion`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`customer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `address` INT(11) NULL DEFAULT NULL,
  `user` INT(11) NOT NULL,
  `profilepicture` VARCHAR(255) NULL DEFAULT NULL,
  `firstname` VARCHAR(255) NOT NULL,
  `lastname` VARCHAR(255) NOT NULL,
  `phonenumber` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_UNIQUE` (`user` ASC),
  INDEX `idx_customer__address` (`address` ASC),
  INDEX `idx_customer__user` (`user` ASC),
  CONSTRAINT `fk_customer__address`
    FOREIGN KEY (`address`)
    REFERENCES `heroku_e95df90031946ad`.`address` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_customer__user`
    FOREIGN KEY (`user`)
    REFERENCES `heroku_e95df90031946ad`.`user` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`property`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`property` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `address` INT(11) NOT NULL,
  `typeofproperty` INT(11) NOT NULL,
  `usage` INT(11) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `image1` VARCHAR(255) NULL DEFAULT NULL,
  `image2` VARCHAR(255) NULL DEFAULT NULL,
  `image3` VARCHAR(255) NULL DEFAULT NULL,
  `size` INT(11) NOT NULL,
  `numberofrooms` TINYINT(4) NOT NULL,
  `furnishingstate` INT(11) NOT NULL,
  `price` DECIMAL(15,2) NOT NULL,
  `yearbuilt` SMALLINT(6) NOT NULL,
  `employee` INT(11) NOT NULL,
  `posted` DATETIME NOT NULL,
  `overview` VARCHAR(255) NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_property__address` (`address` ASC),
  INDEX `idx_property__typeofproperty` (`typeofproperty` ASC),
  INDEX `idx_property__usage` (`usage` ASC),
  INDEX `fk_property_furnishingstate_idx` (`furnishingstate` ASC),
  CONSTRAINT `fk_property__address`
    FOREIGN KEY (`address`)
    REFERENCES `heroku_e95df90031946ad`.`address` (`id`),
  CONSTRAINT `fk_property__typeofproperty`
    FOREIGN KEY (`typeofproperty`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`),
  CONSTRAINT `fk_property__usage`
    FOREIGN KEY (`usage`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`),
  CONSTRAINT `fk_property_furnishingstate`
    FOREIGN KEY (`furnishingstate`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`customer_favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`customer_favorites` (
  `customer` INT(11) NOT NULL,
  `property` INT(11) NOT NULL,
  PRIMARY KEY (`customer`, `property`),
  INDEX `idx_customer_favorites` (`property` ASC),
  CONSTRAINT `fk_customer_favorites__customer`
    FOREIGN KEY (`customer`)
    REFERENCES `heroku_e95df90031946ad`.`customer` (`id`),
  CONSTRAINT `fk_customer_favorites__property`
    FOREIGN KEY (`property`)
    REFERENCES `heroku_e95df90031946ad`.`property` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`employee` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `company` INT(11) NOT NULL,
  `address` INT(11) NULL DEFAULT NULL,
  `user` INT(11) NOT NULL,
  `designation` INT(11) NOT NULL,
  `profilepicture` VARCHAR(255) NULL DEFAULT NULL,
  `firstname` VARCHAR(255) NOT NULL,
  `lastname` VARCHAR(255) NOT NULL,
  `phonenumber` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_UNIQUE` (`user` ASC),
  INDEX `idx_employee__address` (`address` ASC),
  INDEX `idx_employee__company` (`company` ASC),
  INDEX `idx_employee__designation` (`designation` ASC),
  INDEX `idx_employee__user` (`user` ASC),
  CONSTRAINT `fk_employee__address`
    FOREIGN KEY (`address`)
    REFERENCES `heroku_e95df90031946ad`.`address` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_employee__company`
    FOREIGN KEY (`company`)
    REFERENCES `heroku_e95df90031946ad`.`company` (`id`),
  CONSTRAINT `fk_employee__designation`
    FOREIGN KEY (`designation`)
    REFERENCES `heroku_e95df90031946ad`.`typevalue` (`id`),
  CONSTRAINT `fk_employee__user`
    FOREIGN KEY (`user`)
    REFERENCES `heroku_e95df90031946ad`.`user` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`feedback` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `message` VARCHAR(1000) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`message` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `message` LONGTEXT NOT NULL,
  `fromuser` INT(11) NOT NULL,
  `touser` INT(11) NOT NULL,
  `messagedatetime` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_message__from` (`fromuser` ASC),
  INDEX `idx_message__to` (`touser` ASC),
  CONSTRAINT `fk_message__from`
    FOREIGN KEY (`fromuser`)
    REFERENCES `heroku_e95df90031946ad`.`user` (`id`),
  CONSTRAINT `fk_message__to`
    FOREIGN KEY (`touser`)
    REFERENCES `heroku_e95df90031946ad`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`url`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`url` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `urlname` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`role_urls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`role_urls` (
  `role` INT(11) NOT NULL,
  `url` INT(11) NOT NULL,
  PRIMARY KEY (`role`, `url`),
  INDEX `idx_role_urls` (`url` ASC),
  CONSTRAINT `fk_role_urls__role`
    FOREIGN KEY (`role`)
    REFERENCES `heroku_e95df90031946ad`.`role` (`id`),
  CONSTRAINT `fk_role_urls__url`
    FOREIGN KEY (`url`)
    REFERENCES `heroku_e95df90031946ad`.`url` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`sale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`sale` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `employee` INT(11) NOT NULL,
  `price` DECIMAL(15,2) NOT NULL,
  `saletime` DATETIME NOT NULL,
  `customer_name` VARCHAR(255) NOT NULL,
  `customer_email` VARCHAR(255) NOT NULL,
  `property_title` VARCHAR(255) NOT NULL,
  `property_address` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_sale__employee` (`employee` ASC),
  CONSTRAINT `fk_sale__employee`
    FOREIGN KEY (`employee`)
    REFERENCES `heroku_e95df90031946ad`.`employee` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `heroku_e95df90031946ad`.`userlog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `heroku_e95df90031946ad`.`userlog` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ipaddress` VARCHAR(255) NOT NULL,
  `logindt` DATETIME NULL DEFAULT NULL,
  `logoutdt` DATETIME NULL DEFAULT NULL,
  `user` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_userlog__user` (`user` ASC),
  CONSTRAINT `fk_userlog__user`
    FOREIGN KEY (`user`)
    REFERENCES `heroku_e95df90031946ad`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `heroku_e95df90031946ad` ;

-- -----------------------------------------------------
-- procedure create_company_with_admin
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `create_company_with_admin`(
	IN company_name VARCHAR(255),
	IN vorname VARCHAR(255),
    IN lastname VARCHAR(255),
    IN email VARCHAR(255),
    IN `password` VARCHAR(255),
    IN securityquestion INT(11),
    IN securityanswer VARCHAR(255)
)
BEGIN

	DECLARE role_id INT(11) DEFAULT 0;
    DECLARE user_id INT(11) DEFAULT 0;
    DECLARE company_id INT(11) DEFAULT 0;
    DECLARE designation_id INT(11) DEFAULT 0;
    DECLARE employee_id INT(11) DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
	  	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
        -- fetch role id
		SELECT r.id INTO role_id
        FROM role r
        WHERE lower(r.rolename) = lower('COMPANY_ADMIN');
        
		-- create user
		INSERT INTO `user`
		(securityquestion,
		role,
		email,
		`password`,
		securityanswer)
		VALUES
		(securityquestion,
		role_id,
		email,
		`password`,
		securityanswer);

		-- fetch user id
		SELECT u.id INTO user_id
		FROM `user` u
		WHERE lower(u.email) = lower(email);
		
        -- create company
		INSERT INTO company
		(`name`)
		VALUES(company_name);
		
		-- fetch company id
		SELECT comp.id INTO company_id
		FROM company comp
		WHERE comp.`name` = company_name;
        
        -- fetch designation id
        SELECT tv.id INTO designation_id
		FROM typevalue tv, `type` t
		WHERE tv.parenttype = t.id
		AND lower(t.name) = lower('DESIGNATION')
        AND lower(tv.`value`) = lower('Company Admin');
        
		-- create employee
		INSERT INTO employee
		(`user`,
		company,
		designation,
        firstname,
		lastname)
		VALUES
		(user_id,
        company_id,
        designation_id,
		vorname,
		lastname);

		-- fetch employee id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		SELECT emp.id INTO employee_id
		FROM employee emp
		WHERE emp.`user` = user_id;
    
    -- update user record with employee id
    UPDATE user u
    SET u.companyadmin = employee_id
    WHERE u.id = user_id;

    SELECT emp.id
		FROM employee emp
		WHERE emp.`user` = user_id;

	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_customer
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `create_customer`(
	IN vorname VARCHAR(255),
    IN lastname VARCHAR(255),
    IN email VARCHAR(255),
    IN `password` VARCHAR(255),
    IN securityquestion INT(11),
    IN securityanswer VARCHAR(255)
)
BEGIN

	DECLARE role_id INT(11) DEFAULT 0;
    DECLARE user_id INT(11) DEFAULT 0;
    DECLARE address_id INT(11) DEFAULT 0;
    DECLARE cust_id INT(11) DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
	  	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
        -- fetch role id
		SELECT r.id INTO role_id
        FROM role r
        WHERE lower(r.rolename) = lower('CUSTOMER');
        
		-- create user
		INSERT INTO `user`
		(securityquestion,
		role,
		email,
		`password`,
		securityanswer)
		VALUES
		(securityquestion,
		role_id,
		email,
		`password`,
		securityanswer);

		-- fetch user id
		SELECT u.id INTO user_id
		FROM `user` u
		WHERE lower(u.email) = lower(email);
		
		-- create customer
		INSERT INTO customer
		(`user`,
		firstname,
		lastname)
		VALUES
		(user_id,
		vorname,
		lastname);

		-- fetch customer id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		SELECT c.id INTO cust_id
		FROM customer c
		WHERE c.`user` = user_id;

    -- update user record
    UPDATE user u 
    SET u.customer = cust_id
    WHERE u.id = user_id;

    SELECT c.id
		FROM customer c
		WHERE c.`user` = user_id;
        
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_employee
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `create_employee`(
	IN compadminid INT(11),
	IN vorname VARCHAR(255),
    IN lastname VARCHAR(255),
    IN email VARCHAR(255),
    IN `password` VARCHAR(255),
    IN securityquestion INT(11),
    IN securityanswer VARCHAR(255)
)
BEGIN

	DECLARE role_id INT(11) DEFAULT 0;
    DECLARE user_id INT(11) DEFAULT 0;
    DECLARE emp_id INT(11) DEFAULT 0;
    DECLARE company_id INT(11) DEFAULT 0;
    DECLARE designation_id int(11) DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
	  	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
        -- fetch role id
		SELECT r.id INTO role_id
        FROM role r
        WHERE lower(r.rolename) = lower('LISTING_AGENT');
        
		-- create user
		INSERT INTO `user`
		(securityquestion,
		role,
		email,
		`password`,
		securityanswer)
		VALUES
		(securityquestion,
		role_id,
		email,
		`password`,
		securityanswer);

		-- fetch user id
		SELECT u.id INTO user_id
		FROM `user` u
		WHERE lower(u.email) = lower(email);
        
        SELECT emp.company INTO company_id
        FROM employee emp 
        WHERE emp.id = compadminid;
		
        SELECT tv.id INTO designation_id
		FROM typevalue tv, `type` t
		WHERE tv.parenttype = t.id
		AND lower(t.name) = lower('DESIGNATION')
        AND lower(tv.`value`) = lower('Listing Agent');
        
		-- create customer
		INSERT INTO employee
		(`user`,
        company,
		firstname,
		lastname,
        designation)
		VALUES
		(user_id,
        company_id,
		vorname,
		lastname, 
        designation_id);

		-- fetch customer id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		SELECT e.id INTO emp_id
		FROM employee e
		WHERE e.`user` = user_id;

    -- update user record
    UPDATE `user` u 
    SET u.employee = emp_id
    WHERE u.id = user_id;

    SELECT e.id
		FROM employee e
		WHERE e.`user` = user_id;
        
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_property
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `create_property`(
	IN title VARCHAR(255),
    IN size INT(11),
    IN numberofrooms TINYINT(4),
    IN furnishingstate INT(11),
    IN price DECIMAL(15,2),
    IN yearbuilt SMALLINT(6),
    IN employee INT(11),
    IN posted DATETIME,
    IN overview VARCHAR(255),
    IN description LONGTEXT,
    IN city VARCHAR(80),
    IN street VARCHAR(255),
    IN housenumber VARCHAR(100),
    IN plz INT(16),
    IN state VARCHAR(50),
    IN country VARCHAR(80),
    IN image1 VARCHAR(255),
    IN image2 VARCHAR(255),
    IN image3 VARCHAR(255)
)
BEGIN

	DECLARE address_id INT(11) DEFAULT 0;
    DECLARE top_id INT(11) DEFAULT 12;	 -- House
    DECLARE usage_id INT(11) DEFAULT 15;	-- Residential
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
        INSERT INTO address
        (address.city,
        address.country,
        address.housenumber,
        address.plz,
        address.state,
        address.street)
        VALUES
        (city, country, housenumber, plz, state, street);
        
        SELECT LAST_INSERT_ID() into address_id;

		INSERT INTO property
        (property.address, property.description, property.employee, property.furnishingstate, property.numberofrooms, property.overview,
         property.posted, property.price, property.size, property.title, property.typeofproperty, property.`usage`, property.yearbuilt, property.image1, property.image2, property.image3)
         VALUES
         (address_id, description, employee, furnishingstate, numberofrooms, overview, posted, price, size, title, top_id, usage_id, yearbuilt, image1, image2, image3);
         
         SELECT last_insert_id();
         
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_sale
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `create_sale`(
	IN empID INT(11),
    IN custname VARCHAR(255),
    IN custemail VARCHAR(255),
    IN price DECIMAL(15,2),
    IN saletime DATETIME,
    IN prop_id INT(11)
)
BEGIN

	DECLARE prop_title VARCHAR(255) DEFAULT '';
    DECLARE prop_address VARCHAR(1024) DEFAULT '';
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
        -- fetch property details
		SELECT p.title, CONCAT_WS(',', addr.street, addr.housenumber, addr.plz, addr.city, addr.state, addr.country) INTO prop_title, prop_address
        FROM property p, address addr
        WHERE p.address = addr.id AND p.id = prop_id;
        
		-- create user
		INSERT INTO sale
		(employee,
		price,
		saletime,
		customer_name,
		customer_email,
        property_title,
        property_address)
		VALUES
		(empID,
		price,
		saletime,
		custname,
		custemail,
        prop_title,
        prop_address);

		SELECT LAST_INSERT_ID();
        
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure edit_customer
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `edit_customer`(
	IN cust_id INT(11),
    IN firstname VARCHAR(255),
    IN lastname VARCHAR(255),
    IN email VARCHAR(255),
    IN phone VARCHAR(255),
    IN city VARCHAR(80),
    IN street VARCHAR(255),
    IN hno VARCHAR(100),
    IN plz INT(16),
    IN state VARCHAR(50),
    IN country VARCHAR(80)
)
BEGIN

    DECLARE address_id INT(11) DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
	  	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
		UPDATE customer 
        SET 
			firstname = firstname, 
            lastname = lastname,
		    phonenumber = phone 
		WHERE id = cust_id; 
        
        SELECT address INTO address_id 
        FROM customer 
        WHERE id = cust_id;
        
        IF address_id IS NULL THEN
			
            INSERT INTO address 
            (housenumber, street, city, state, country, plz) 
            VALUES (hno, street, city, state, country, plz);
            
            UPDATE customer SET address =  LAST_INSERT_ID() where id = cust_id;
            
		ELSE
        
			UPDATE address 
            SET
				housenumber = hno,
                street = street,
                city = city,
                state = state,
                country = country,
                plz = plz
			WHERE id = address_id;
		END IF;
        
		UPDATE `user`
        SET
			email = email
		WHERE customer = cust_id;
        
        SELECT cust_id;
        
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure edit_employee
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `edit_employee`(
	IN emp_id INT(11),
    IN firstname VARCHAR(255),
    IN lastname VARCHAR(255),
    IN email VARCHAR(255),
    IN phone VARCHAR(255),
    IN city VARCHAR(80),
    IN street VARCHAR(255),
    IN hno VARCHAR(100),
    IN plz INT(16),
    IN state VARCHAR(50),
    IN country VARCHAR(80)
)
BEGIN

    DECLARE address_id INT(11) DEFAULT 0;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		-- ERROR
	  	ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		-- WARNING
	 	ROLLBACK;
	END;

	START TRANSACTION;
		
		UPDATE employee 
        SET 
			firstname = firstname, 
            lastname = lastname,
		    phonenumber = phone 
		WHERE id = emp_id; 
        
        SELECT address INTO address_id 
        FROM employee 
        WHERE id = emp_id;
        
        IF address_id IS NULL THEN
			
            INSERT INTO address 
            (housenumber, street, city, state, country, plz) 
            VALUES (hno, street, city, state, country, plz);
            
            UPDATE employee SET address =  LAST_INSERT_ID() where id = emp_id;
            
		ELSE
        
			UPDATE address 
            SET
				housenumber = hno,
                street = street,
                city = city,
                state = state,
                country = country,
                plz = plz
			WHERE id = address_id;
		END IF;
        
		UPDATE `user`
        SET
			email = email
		WHERE employee = emp_id OR companyadmin = emp_id;
        
        SELECT emp_id;
        
	 COMMIT;
     
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_property_filters
-- -----------------------------------------------------

DELIMITER $$
USE `heroku_e95df90031946ad`$$
CREATE PROCEDURE `get_property_filters`(
	IN fetch_locations TINYINT(1),
    IN fetch_options TINYINT(1)
)
BEGIN
	
    IF 1 = fetch_locations
    THEN
    
		-- fetch cities
		SELECT DISTINCT addr.city
		FROM address addr;
	
    END IF;
    
    -- fetch property sizes
    SELECT tv.id, tv.value
	FROM typevalue tv, `type` t
	WHERE tv.parenttype = t.id
	AND LOWER(t.name) = LOWER('PROPERTY_SIZE_FILTER');
    
    -- fetch property furnishing states
    SELECT tv.id, tv.value
	FROM typevalue tv, `type` t
	WHERE tv.parenttype = t.id
	AND LOWER(t.name) = LOWER('FURNISHING_STATE');
    
    IF 1 = fetch_options
    THEN
    
		-- fetch property sort options
		SELECT tv.id, tv.value
		FROM typevalue tv, `type` t
		WHERE tv.parenttype = t.id
		AND LOWER(t.name) = LOWER('PROPERTY_SORT');

	END IF;
    
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
