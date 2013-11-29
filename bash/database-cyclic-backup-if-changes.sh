#!/bin/bash

MYSQL_USER=root
MYSQL_PASS="foo"

# Take a backup and compare it with the latest
LATEST_BACKUP=$(ls -t1 sportfi.*.sql.gz | head -n 1)
FILENAME=sportfi.`date +%d.%m.%Y-%H:%M:%S`.sql
mysqldump sportfi -u $MYSQL_USER  --password=$MYSQL_PASS > $FILENAME
gzip $FILENAME
FILENAME="$FILENAME.gz"

diff --brief $FILENAME $LATEST_BACKUP >/dev/null
comp_value=$?

echo "Compare latest $LATEST_BACKUP to $FILENAME"
if [ $comp_value -eq 1 ]
then
    echo "There are changes in the database. Keeping backup"
else
    echo "No changes. Removing backup $FILENAME"
    rm $FILENAME
fi

# Keep the amount of backups limited MAX_BACKUPS
MAX_BACKUPS=14
CURRENT_AMOUNT_OF_BACKUPS=$(ls *.sql.gz | wc -l)
NEED_TO_DELETE=$(($CURRENT_AMOUNT_OF_BACKUPS - $MAX_BACKUPS))
if [ $NEED_TO_DELETE -gt 0 ]
then
    echo "Too many backups kept, need to delete $NEED_TO_DELETE"
    BACKUPS_FOR_DELETION=$(ls -1cr | head -n $NEED_TO_DELETE)
    # echo "these have to go $BACKUPS_FOR_DELETION"
    for b in $BACKUPS_FOR_DELETION; do
        rm $b
    done
else
    echo "Keeping all since maximum of $MAX_BACKUPS not reached with $CURRENT_AMOUNT_OF_BACKUPS"
fi

