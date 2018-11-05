# Simple bash script to take an encrypted mysql backup hourly.

### Installation.

```sh
$ cp mysqlhourlybackup.sh /usr/local/bin && chmod +x /usr/local/bin/mysqlhourlybackup.sh
```


Edit the variables 

```sh
nano /usr/local/bin/mysqlhourlybackup.sh
```
* set MYSQL_USER
* set MYSQL_PASSWORD
* set MYSQL_HOST
* set ENCRYPTPASSWORD

## Open Crontab and setup new hourly job.

```sh
crontab -e
```

00 * * * * /usr/local/bin/mysqlhourlybackup.sh >/dev/null 2>&1


## Details on how to unencrypt the backups. 

```sh
openssl enc -aes-256-cbc -d -in *dbname.enc* -out database.gz -pass pass:*encryptionpassword*  && gunzip -c database.gz > *dbname.sql*
```
