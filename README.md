# Simple bash script to take an encrypted mysql backup hourly.

### Installation

```sh
$ cp mysqlhourlybackup.sh into /usr/local/bin
```
```sh
chmod 700 /usr/local/bin/mysqlhourlybackup.sh
```

Edit the variables 

```sh
nano /usr/local/bin/mysqlhourlybackup.sh
```
* set MSQL_USER
* set MYSQL_PASSWORD
* set MYSQL_HOST
* set ENCRYPTPASSWORD

## Open Crontab and setup new hourly job ##

```sh
crontab -e
```

00 * * * * /usr/local/bin/mysqlhourlybackup.sh >/dev/null 2>&


## Unencrypt the backups 

```sh
openssl enc -aes-256-cbc -d -in dbname.sql.gz.enc -out dbname.gz -pass pass:*encryptionpassword* 
gunzip -c dbname.gz > dbname.sql
```
