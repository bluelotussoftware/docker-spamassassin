#!/bin/sh

while true
do
    sleep 1m
    echo "Updating SpamAssassin rules"
    #su alpine-spamd -c 'sa-update' && kill -HUP `cat /var/run/spamd.pid`
    sa-update && kill -HUP `cat /var/run/spamd.pid`
    echo "SpamAssassin rules updated sleeping for 1 day"
    sleep 1d
done
