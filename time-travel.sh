#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------
DESTINATION="$1"

# -----------------------------------------------------------------------------
# Run rsync-time-backup
# -----------------------------------------------------------------------------
./rsync-time-backup/rsync_tmbackup.sh /Users $DESTINATION

# -----------------------------------------------------------------------------
# Create notification-center popup
# -----------------------------------------------------------------------------
./terminal-notifier/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Time Travel" -message "Backup started..."
