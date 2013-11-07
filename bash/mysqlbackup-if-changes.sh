#!/bin/bash

LATEST_BACKUP=$(ls -t1 sportfi.*.sql.gz | head -n 1)

FILENAME=sportfi.`date +%d.%m.%Y-%H:%M:%S`.sql
mysqldump sportfi -u sportfi --password="M13t0sev44nhiiht44" > $FILENAME
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
#    rm $FILENAME
fi


