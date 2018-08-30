CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'newpassword';
GRANT ALL PRIVILEGES ON *geodata* TO 'newuser'@'localhost';
FLUSH PRIVILEGES;
