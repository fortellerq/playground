#!/bin/bash
#
# forteller 23.09.2024
#
# 24/09/23 - v0.1 - initial version
#
# Usage: ./backup_openwrt.sh [IP] [port] [keyfile_path] [target_path]

#Variables definitions
line="\n------------------------------------------------------------------------------\n"
ip="$1"
port="$2"
key_path="$3"
target_path="$4"

#Actual logic
$target_dir

echo "ssh"
ssh $ip -p $port -i $key_path 'mkdir -p /root/backup && sysupgrade -q -b /root/backup/backup-${HOSTNAME}-$(date +%F).tar.gz'
echo "scp"
scp -P $port -i $key_path root@$ip:/root/backup/* $target_path
exit 0;
