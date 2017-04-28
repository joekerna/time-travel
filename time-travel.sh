#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------
SOURCE="$1"
DESTINATION="$2"
TMPDIR=/tmp

# -----------------------------------------------------------------------------
# Create notification-center popup
# -----------------------------------------------------------------------------
./terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup started..."

# -----------------------------------------------------------------------------
# Run rsync-time-backup
# -----------------------------------------------------------------------------
./rsync-time-backup/rsync_tmbackup.sh --rsync-set-flags "-D --compress --numeric-ids --links --hard-links --one-file-system --itemize-changes --times --recursive --perms --owner --group --stats -h" $SOURCE $DESTINATION > $TMPDIR/time-travel.log

# -----------------------------------------------------------------------------
# Create notification-center popup
# -----------------------------------------------------------------------------
TOTALTRANSFERREDSIZE=$(grep 'Total transferred file size' $TMPDIR/time-travel.log)
./terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "$TOTALTRANSFERREDSIZE"

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
rm -rf $TMPDIR/time-travel.log
