# admin account 
# SECURITY: change password after first login
#
# TICKET 4342: Security problem with multiple Testlink installations on the same server 
INSERT INTO /*prefix*/users (login,password,role_id,email,first,last,locale,active,cookie_string)
			VALUES ('admin',MD5('test'), 8,'', 'Testlink','Administrator', 'en_GB',1,CONCAT(MD5(RAND()),MD5('admin')));

