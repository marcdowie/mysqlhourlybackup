# Simple bash script to take an encrypted mysql backup hourly #

copy mysqlhourlybackup.sh into /usr/local/bin

chmod 700 /usr/local/bin/mysqlhourlybackup.sh


Edit the variables 

nano /usr/local/bin/mysqlhourlybackup.sh

set MSQL_USER
set MYSQL_PASSWORD
set MYSQL_HOST

## Open Crontab and setup new hourly job ##

crontab -e

00 * * * * /usr/local/bin/mysqlhourlybackup.sh >/dev/null 2>&


## to un-encrypt the backups ##

openssl enc -aes-256-cbc -d -in dbname.sql.gz.enc -out dbname.gz -pass pass:*encryptionpassword* 
gunzip -c dbname.gz > dbname.sql

