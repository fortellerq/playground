#!/bin/bash
#
# forteller 24.06.2023

printf "Stopping: "
docker stop portainer

printf "Removing: "
docker rm portainer

printf "Pulling latest portainer image: "
docker pull portainer/portainer-ce:latest

printf "Starting new portainer container: "
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
