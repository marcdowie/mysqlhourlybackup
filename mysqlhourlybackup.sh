#!/bin/sh

################################################################
#  Start Variables
################################################################

MYSQL_USER=root
MYSQL_PASSWORD=password
MYSQL_HOST=localhost
MYSQL_DBNAME=--all-databases
BACKUP_DIR=/mysqlbackup/hourly
ENCRYPTPASSWORD=encryptionpassword
BACKUPSTOKEEP=3

################################################################
#  End Variables
################################################################

OUTPUTFILENAME="`hostname -s`_MYSQLBACKUP_`date +%F_%H-%M-%S`"

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
        rm $BACKUP_DIR/*.gz

DELETEOLDFILES=$(ls -t1 $BACKUP_DIR | tail -n +$(($BACKUPSTOKEEP+1)))

if [ -n "$DELETEOLDFILES" ]; then
    ls -t1 $BACKUP_DIR | tail -n +$(($BACKUPSTOKEEP+1)) | xargs rm
fi

################################################################
#   Unencrypt backup file using the following
################################################################
#
#openssl enc -aes-256-cbc -d -in dbname.sql.gz.enc -out dbname.gz -pass pass:*encryptionpassword*
#gunzip -c dbname.gz > dbname.sql
#
################################################################
#   Unencrypt backup file using the following
################################################################

