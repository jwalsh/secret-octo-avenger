#!/bin/sh
# Create reasonably spaced times for commits for dashboard reporting
MEAN_DAYS=3
SECONDS_PER_DAY=86400
let BASE_INCREMENT=$MEAN_DAYS*$SECONDS_PER_DAY
# Wed, 01 Jan 2014 06:54:04 GMT
START=1388559244
# Wed, 31 Dec 2014 06:54:04 GMT
END=1420008844
CURRENT="$START"

EXAMPLE=data/example.$$

while [ "$CURRENT" -lt "$END" ]
do
    # RANDOM is less than 32k so we use that as our mean
    let DISTRIBUTION=2*$RANDOM/32767
    let INCREMENT=$BASE_INCREMENT*DISTRIBUTION
    (( CURRENT += $INCREMENT ))
    DATE=$(date -d @$CURRENT +"%d-%m-%Y")
    echo $DISTRIBUTION $CURRENT $DATE
    # Options:
    # http://www.thegeekstuff.com/2012/11/linux-touch-command/
    # -d to set the date
    # Change the base date for the file
    touch -d "$(date -d @$CURRENT)" $EXAMPLE
    ls -la $EXAMPLE
    # http://giantdorks.org/alain/how-to-reset-date-timestamps-for-one-or-more-git-commits/
    git add $EXAMPLE
    git commit --date="$(stat -c %y $EXAMPLE)" -m "Timing $RANDOM" $EXAMPLE


done
