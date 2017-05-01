#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------
SOURCE="$1"
DESTINATION="$2"
EXCLUDE_FILE="$3"
TMPDIR=/tmp
SCRIPTDIR=$(dirname $0)

# -----------------------------------------------------------------------------
# notification-center start popup
# -----------------------------------------------------------------------------
$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup started..."

# -----------------------------------------------------------------------------
# Run rsync-time-backup
# -----------------------------------------------------------------------------
nice -n 10 $SCRIPTDIR/rsync-time-backup/rsync_tmbackup.sh --rsync-set-flags "-D --compress --numeric-ids --links --hard-links --one-file-system --itemize-changes --times --recursive --perms --owner --group --stats -h" $SOURCE $DESTINATION $EXCLUDE_FILE > $TMPDIR/time-travel.log

# -----------------------------------------------------------------------------
# notification-center popup with summary
# -----------------------------------------------------------------------------
TOTALTRANSFERREDSIZE=$(grep 'Total transferred file size' $TMPDIR/time-travel.log)
if [ -z "$TOTALTRANSFERREDSIZE" ]; then
	# Error
	$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup was interrupted"
else
	$SCRIPTDIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "$TOTALTRANSFERREDSIZE"
fi

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
rm -rf $TMPDIR/time-travel.log
