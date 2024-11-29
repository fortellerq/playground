# playground
Place for my personal scripts, mostly written in bash meant for Debian.

## portainer_update.sh
Simple script for keeping portainer up to date.
Developed in need to maintain my NASes which are running openmediavault distribution. Changes done in May 2023 removed Portainer visibility from the Web GUI with intention to use omv GUI to maintain Docker.

This script has been made out of frustration, but it basically does what "Install Portainer" button did in the past on omv5 and omv6.

As an omv user since omv3 this makes me mad. With omv3->omv4 transition omv creators enforced the use of Docker for basic NAS functionality by not porting over many previously existing omv plugins with intention to use docker instead. Back then, they provided a plugin with crappy GUI for maintaining the docker environment. With omv4->omv5 they removed this plugin and forced everyone to use portainer. Now mid-omv6 existence, basic functionality is changed once more and after some update, whole part of the system has been removed and they want me to use their plugin again. And of course there is some Portainer->OMV transition tutorial to follow and new GUI to learn.

This is just a temporary solution. I intend to move away from omv, because this is not the first time they pull such thing off.

## backup.sh
Simple backup script I have written for my personal needs.

Syntax: ./backup.sh <source_dir> <target_dir>

It creates .tar archive from directory given as a first argument and places it in target directory specified in second argument. Then, it deletes any files in target directory that are older than 5 days.

!!! Be cautious when specifying target directory !!!

## backup_openwrt.sh
Quick and dirty script for making OpenWRT router backups. Meant to be part of cron.

## backup_routeros.sh
Another quick and dirty script for making routerOS device backups. Basically a copy of backup_openwrt.sh so the same rules apply. Execution differs, cause you need to provide remote ssh user as execution parameter.

## e1000e_fix.sh
Fixes Intel Gigabit NIC random shutdowns when under load. You need to specify adapter name in the argument.

More specifically, it disables hardware flow control for specified adapter and adds appropiate command to crontab that is launched on every reboot.

If entry for specified adapter exists already in crontab, no changes are done to crontab.

## gb3parse.py
Script that ChatGPT produced and I slightly modified. It parses output of Geekbench 3 benchmark results and presents it in CSV which then can be easily imported into Excel which I maintain.

## gb5parse.py
Script that ChatGPT produced and I slightly modified. It parses output of Geekbench 5 benchmark results and presents it in CSV which then can be easily imported into Excel which I maintain.

## sysinfo.sh
Very slight modification of sysinfo.sh script that is part of eko.one.pl OpenWRT releases.

Usually this script resides in /sbin/sysinfo.sh. When switching to any other OpenWRT fork (official one for example), /sbin directory gets overwritten leaving user with ugly error every login:
```
-ash: /etc/profile.d/99-sysinfo.sh: /sbin/sysinfo.sh: not found
```
Solution is to store this file in a location that does not get overwritten every uptade, for example in /root/sysinfo.sh.

This script modifies line formatting to optimize line formatting against usual 80 cols instead of lenght of /etc/banner (which can differ across different OpenWRT forks).

Finally, additional line is added at top for improved looks of the output.

After all of this, here is welcome screen after successful OpenWRT login

```
BusyBox v1.36.1 (2023-11-15 10:00:19 UTC) built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 23.05.2, r23630-842932a63d
 -----------------------------------------------------
 -------------------------------------------------------------------------------
 | Machine: Xiaomi AX3600                                                      |
 | Uptime: 6d, 23:51:43                                                        |
 | Load: 0.00 0.00 0.00                                                        |
 | Flash: total: 173.6MB, free: 168.7MB, used: 0%                              |
 | Memory: total: 407.6MB, free: 158.4MB, used: 61%                            |
 | Leases: 0                                                                   |
 | lan: dhcp, <ERASED_FOR_SECURITY>                                            |
 | guest: none, ?                                                              |
 | iot: static, <ERASED_FOR_SECURITY>                                          |
 | radio1: lan, mode: ap, ssid: PMR-NETWORK-5G, channel: 104, conn: 1          |
 | radio2: guest, mode: ap, ssid: PMR-GUEST, channel: 3, conn: 0               |
 | radio2: iot, mode: ap, ssid: PMR-IOT, channel: 3, conn: 8                   |
 -------------------------------------------------------------------------------
```
