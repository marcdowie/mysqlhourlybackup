#!/bin/sh

################################################################
#  Variables
################################################################

MYSQL_USER=root
MYSQL_PASSWORD=password
MYSQL_HOST=localhost
MYSQL_DBNAME=--all-databases
ENCRYPTPASSWORD=encryptionpassword
BACKUPSTOKEEP=1


BACKUP_DIR=/mysqlbackup/hourly
OUTPUTFILENAME="`hostname -s`_MYSQLBACKUP_`date +%F_%H-%M-%N`"


echo "CHECKING FOR BACKUP DIRECTORY"

        if [ ! -d $BACKUP_DIR ]; then
            mkdir -p $BACKUP_DIR
        fi

echo "BACKUP IN PROGRESS"

        mysqldump --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DBNAME | gzip > $BACKUP_DIR/$OUTPUTFILENAME.gz

################################################################
#Comment out the next 3 lines if you want encryption disabled.
################################################################
echo "ENCRYPTION IN PROGRESS"

	openssl enc -aes-256-cbc -e -in $BACKUP_DIR/$OUTPUTFILENAME.gz -out $BACKUP_DIR/$OUTPUTFILENAME.enc -pass pass:$ENCRYPTPASSWORD

################################################################
#increase +2 if more than 1 backup is needed
################################################################

echo "DELETING OLD BACKUPS"

      cd $BACKUP_DIR
      ls -t1 | grep *.gz | xargs rm
      ls -t1 | tail -n +$(($BACKUPSTOKEEP+1)) | xargs rm


################################################################
#   Unencrypt backup file using the following
################################################################

#openssl enc -aes-256-cbc -d -in dbname.sql.gz.enc -out dbname.gz -pass pass:*encryptionpassword* 
#gunzip -c dbname.gz > dbname.sql

