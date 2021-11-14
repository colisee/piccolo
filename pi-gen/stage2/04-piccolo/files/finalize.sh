#!/bin/bash

##  Copyright (C) 2021  Robin ALEXANDER
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Retrieve the servet setup values 
source /boot/myconfig

# DELETE EXISTING DOCKER OBJECTS
docker container rm --force --volumes $(docker container ls -aq)
docker network prune --force
docker volume prune --force

# CREATE DOCKER NETWORK
docker network create piccolo

# START DOCKER IMAGES

## Start nginx proxy 
docker run \
  --detach \
  --name nginx-proxy \
  --restart always \
  --network piccolo \
  --publish 80:80 \
  --publish 443:443 \
  --volume certs:/etc/nginx/certs \
  --volume vhost:/etc/nginx/vhost.d \
  --volume html:/usr/share/nginx/html \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  nginxproxy/nginx-proxy

## Let's Encrypt companion to nginx proxy
docker run \
  --detach \
  --name nginx-proxy-acme \
  --restart always \
  --network piccolo \
  --volumes-from nginx-proxy \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  --volume acme:/etc/acme.sh \
  nginxproxy/acme-companion

## Start Postgres
docker run \
  --detach \
  --name postgres \
  --restart always \
  --network piccolo \
  --volume postgres:/var/lib/postgresql/data \
  --env "POSTGRES_PASSWORD=${ADMIN_PASSWORD}" \
  postgres:latest

## Start Nextcloud
proxyIP=$(docker container inspect npm | grep IPAddress | tail -n 1 | cut -d '"' -f 4)
docker run \
  --detach \
  --name nextcloud \
  --restart always \
  --network piccolo \
  --volume nextcloud:/var/www/html  \
  --env "NEXTCLOUD_ADMIN_USER=${ADMIN_USER}" \
  --env "NEXTCLOUD_ADMIN_PASSWORD=${ADMIN_PASSWORD}" \
  --env "NEXTCLOUD_TRUSTED_DOMAINS=cloud.${DOMAIN}"  \
  --env "POSTGRES_HOST=postgres" \
  --env "POSTGRES_USER=postgres" \
  --env "POSTGRES_PASSWORD=${ADMIN_PASSWORD}" \
  --env "POSTGRES_DB=nextcloud" \
  --env "APACHE_DISABLE_REWRITE_IP=1" \
  --env "TRUSTED_PROXIES=${proxyIP}" \
  --env "VIRTUAL_HOST=cloud.${DOMAIN}" \
  --env "LETSENCRYPT_HOST=cloud.${DOMAIN}" \
  nextcloud:latest

## Start Wireguard Easy
docker run \
  --detach \
  --name wg-easy \
  --restart always \
  --network piccolo \
  --publish 51820:51820/udp \
  --publish 51821:51821 \
  --cap-add NET_ADMIN \
  --cap-add SYS_MODULE \
  --sysctl net.ipv4.ip_forward=1 \
  --sysctl net.ipv4.conf.all.src_valid_mark=1 \
  --volume wg-easy:/etc/wireguard \
  --env "WG_HOST=vpn.${DOMAIN}" \
  --env "PASSWORD=${ADMIN_PASSWORD}" \
  weejewel/wg-easy

