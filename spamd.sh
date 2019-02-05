#!/bin/sh

spamd --nouser-config \
      --syslog stderr \
      --pidfile /var/run/spamd.pid \
      --helper-home-dir /var/lib/spamassassin \
      --ip-address \
      --allowed-ips 0.0.0.0/0
