#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------
EXIT_CODE="1"
SOURCE="$1"
DESTINATION="$2"
EXCLUDE_FILE="$3"
TMPDIR=/tmp
if [[ ! -d $TMPDIR ]]; then
	TMPDIR=$(mktemp -d)
	echo "/tmp does not exist. Creating temporary directory at " $TMPDIR
fi
SCRIPTDIR=$(dirname $0)

# Create lock file
if [[ ! -f $TMPDIR/.time-travel.lock ]]; then
	touch $TMPDIR/.time-travel.lock
else
	EXIT_CODE="1"
	$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Previous backup still running."
	exit $EXIT_CODE
fi	

# -----------------------------------------------------------------------------
# NOTIFICATION-CENTER STARTUP POPUP
# -----------------------------------------------------------------------------
$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup started..."

# -----------------------------------------------------------------------------
# RUN RSYNC_TIME_BACKUP
# -----------------------------------------------------------------------------
nice -n 10 $SCRIPTDIR/rsync-time-backup/rsync_tmbackup.sh $SOURCE $DESTINATION $EXCLUDE_FILE > $TMPDIR/time-travel.log
# Save rsync-time-backup exit-code
EXIT_CODE=$?

# -----------------------------------------------------------------------------
# ERROR HANDLING
# -----------------------------------------------------------------------------
TOTALTRANSFERREDSIZE=$(grep 'Total transferred file size' $TMPDIR/time-travel.log)
if ([ -z "$TOTALTRANSFERREDSIZE" ] || [$EXIT_CODE != "0"]); then
	# Error
	$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup was interrupted"
	EXIT_CODE="1"
else
	$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "$TOTALTRANSFERREDSIZE"
	EXIT_CODE="0"
fi

# -----------------------------------------------------------------------------
# CLEAN UP
# -----------------------------------------------------------------------------
if [ -z "$TOTALTRANSFERREDSIZE" ]; then
	# Only delete log file in case of success
	rm -rf $TMPDIR/time-travel.log
fi
rm $TMPDIR/.time-travel.lock

exit $EXIT_CODE
