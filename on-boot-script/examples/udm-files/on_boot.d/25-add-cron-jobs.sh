#!/bin/sh

## Store crontab files in /data/cronjobs/ (you will need to create this folder).
## This script will re-add them on startup.

cp /data/cronjobs/* /etc/cron.d/
/etc/init.d/crond restart

exit 0
