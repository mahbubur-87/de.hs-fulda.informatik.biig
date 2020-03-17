CREATE TABLE IF NOT EXISTS user(id INT(11) PRIMARY KEY AUTO_INCREMENT, username VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, securityquestion INT(11) NOT NULL, securityanswer VARCHAR(255) NOT NULL);
INSERT INTO user(username, email, password, securityquestion, securityanswer) VALUES('sysadmin1', 'mahbubur.rahman@informatik.hs-fulda.de', '123456', 1, 'hello world');
INSERT INTO user(username, email, password, securityquestion, securityanswer) VALUES('sysadmin2', 'mahbubur.rahman@informatik.hs-fulda.de', '123457', 1, 'hello world');
INSERT INTO user(username, email, password, securityquestion, securityanswer) VALUES('sysadmin3', 'mahbubur.rahman@informatik.hs-fulda.de', '123458', 1, 'hello world');
