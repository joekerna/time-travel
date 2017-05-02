# time-travel
An rsync based backup script which only transfers modified files. Smooth integration into OSX Notification Center.
It relies mainly on a script named [rsync-time-backup](https://github.com/laurent22/rsync-time-backup) by laurent22 and [terminal-notifier](https://github.com/julienXX/terminal-notifier) by julienXX.
This script combines the powerful backup capabilites of rsync-time-backup with the notification features of terminal-notifier to provide a simple backup alternative to Apple's Time Machine.

# Installation

	git clone https://github.com/joekerna/time-travel
	
	Destination directory has to contain empty file named backup.marker.
	
	touch <DESTINATION>/backup.marker

# Usage

	time-travel.sh <SOURCE> <[USER@HOST:]DESTINATION> [exclude-pattern-file]

