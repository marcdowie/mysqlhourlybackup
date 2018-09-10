#!/bin/sh


#  Variables

BACKUP_DIR=/mysqlbackup/hourly
MYSQL_USER=*dbuser*
MYSQL_PASSWORD=*dbpassword*
MYSQL_HOST=localhost
MYSQL_DBNAME=--all-databases
OUTPUTFILENAME="`hostname -s`_MYSQLBACKUP_`date +%F_%H-%M-%S`"
ENCRYPTPASSWORD=*encryptionpassword*

echo "CHECKING FOR BACKUP DIRECTORY"

        if [ ! -d $BACKUP_DIR ]; then
            mkdir -p $BACKUP_DIR
        fi

echo "BACKUP IN PROGRESS"

        mysqldump --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DBNAME | gzip > $BACKUP_DIR/$OUTPUTFILENAME.gz

echo "ENCRYPTION IN PROGRESS"

	openssl enc -aes-256-cbc -e -in $BACKUP_DIR/$OUTPUTFILENAME.gz -out $BACKUP_DIR/$OUTPUTFILENAME.enc -pass pass:$ENCRYPTPASSWORD

echo "DELETING OLD BACKUPS"

      cd $BACKUP_DIR
      ls -t1 | tail -n +2 | xargs rm


################################################################
#   Unencrypt backup file using the following
################################################################

#openssl enc -aes-256-cbc -d -in dbname.sql.gz.enc -out dbname.gz -pass pass:*password*
