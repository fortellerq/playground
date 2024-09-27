#!/bin/bash
#
# forteller 23.09.2024
#
# 24/09/27 - v0.4 - getting rid of scp to ensure compatibility with ubuntu 24.04
# 24/09/24 - v0.3 - code cleanup, requirement to redirect STDOUT and STDERR, sending mail when fail, target cleanup
# 24/09/23 - v0.2 - added -q and -k options
# 24/09/23 - v0.1 - initial version
#
# Usage: ./backup_openwrt.sh [IP] [PORT] [KEY_PATH] [TARGET_PATH] 1>[STDOUT] 2>[STDERR]

# variables definitions
IP="$1"
PORT="$2"
KEY_PATH="$3"
TARGET_PATH="$4"
STD_OUT=`readlink /proc/$$/fd/1`
STD_ERR=`readlink /proc/$$/fd/2`
MAILTO=root
# ----------------------------------------------------------------------------------------------

# check if STD_OUT / STD_ERR redirected
if [[ "$STD_OUT" == *"/dev/pts"* ]] || [[ "$STD_ERR" == *"/dev/pts"* ]]
 then
  ERRORTXT='this script has to have STDOUT and STDERR redirected to file'
  echo $ERRORTXT >&2
  echo $ERRORTXT | mail -s "Error occured when performing openwrt backup" root
  exit 11
fi

# actual logic
ssh $IP -p $PORT -i $KEY_PATH 'sysupgrade -k -b -' > $TARGET_PATH/backup-$IP-$(date +%F).tar.gz

# send an email if there are errors
if [[ -s $STD_ERR ]]
 then
  echo "errors occured during script execution" >&2
  cat $STD_ERR | mail -s "Error occured when performing openwrt backup" $MAILTO
  exit 10
fi

exit 0
