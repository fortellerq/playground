# playground
Place for my personal scripts, mostly written in bash meant for Debian.

## portainer_update.sh
Simple script for keeping portainer up to date.
Developed in need to maintain my NASes which are running openmediavault distribution. Changes done in May 2023 removed Portainer visibility from the Web GUI with intention to use omv GUI to maintain Docker.

This script has been made out of frustration, but it basically does what "Install Portainer" button did in the past on omv5 and omv6.

As an omv user since omv3 this makes me mad. With omv3->omv4 transition omv creators enforced the use of Docker for basic NAS functionality by not porting over many previously existing omv plugins with intention to use docker instead. Back then, they provided crappy GUI for maintaining the docker environment. With omv4->omv5 they removed this plugin and forced everyone to use portainer. Now mid-omv6 existence, basic functionality is changed and after some update, whole part of the system has been removed and they want me to use their plugin again. And of course there is some Portainer->OMV tutorial to follow and new GUI to learn.

This is just a temporary solution. I intend to move away from omv, because this is not the first time they pull such thing off.
