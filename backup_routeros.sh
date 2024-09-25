#!/bin/bash
#
# forteller 24.09.2024
#
# 24/09/25 - v0.2 - added backup compression
# 24/09/24 - v0.1 - initial version
#
# Usage: ./backup_routeros.sh [IP] [PORT] [KEY_PATH] [TARGET_PATH] [SSH_USER] 1>[STDOUT] 2>[STDERR]

# variables definitions
IP="$1"
PORT="$2"
KEY_PATH="$3"
TARGET_PATH="$4"
SSH_USER="$5"
MAILTO=root
FILENAME=routeros-$(date +%F)
STD_OUT=`readlink /proc/$$/fd/1`
STD_ERR=`readlink /proc/$$/fd/2`
# ----------------------------------------------------------------------------------------------

# check if STD_OUT / STD_ERR redirected
if [[ "$STD_OUT" == *"/dev/pts"* ]] || [[ "$STD_ERR" == *"/dev/pts"* ]]
 then
  ERRORTXT='this script has to have STDOUT and STDERR redirected to file'
  echo $ERRORTXT >&2
  echo $ERRORTXT | mail -s "Error occured when performing routeros backup" root
  exit 11
fi

# actual logic
ssh $SSH_USER@$IP -p $PORT -i $KEY_PATH 'export terse' > $TARGET_PATH/$FILENAME.rsc
tar czf $TARGET_PATH/$FILENAME.tar.gz --remove-files -C $TARGET_PATH $FILENAME.rsc

# send an email if there are errors
if [[ -s $STD_ERR ]]
 then
  echo "errors occured during script execution" >&2
  cat $STD_ERR | mail -s "Error occured when performing routeros backup" $MAILTO
  exit 10
fi

exit 0
