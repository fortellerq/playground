#!/bin/bash
#
# Fixes Intel Gigabit network adapters which suddenly drop connection.
#
# forteller 29.06.2023

if [[ $# -eq 0 ]] ; then
 echo 'You need to provide adapter name as an argument'
 exit 1
fi

COMMAND="ethtool -K $1 tx off rx off"
CRONTAB_ENTRY="@reboot root $COMMAND"

$COMMAND || {
 echo 'ethtool returned error!'
 exit 2 
}

grep "$CRONTAB_ENTRY" /etc/crontab > /dev/null && {
 echo 'crontab entry exists already. Skipping crontab modification'
} || {
 echo $CRONTAB_ENTRY >> /etc/crontab
}

exit 0
