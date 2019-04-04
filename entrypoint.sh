#!/bin/bash
# set -e

# no arguments passed
if [ "$#" -eq 0 ]; then
    # create directory for zones file
    [ ! -d /etc/knot/zones ] && mkdir /etc/knot/zones
    # create empty zone list
    [ ! -f /etc/knot/knot-zones.conf ] && touch /etc/knot/knot-zones.conf
    # copy default knot config into mounted directory
    [ ! -f /etc/knot/knot.conf ] && cp /usr/app/config/knot-default.config /etc/knot/knot.conf && chown knot:knot /etc/knot/knot.conf

    # chown on mounted directory
    chown -R knot:knot /var/lib/knot
    chown knot:knot /etc/knot/zones /etc/knot/knot-zones.conf

    # run app
    rackup -o 0.0.0.0 -p 9292 -E production -D

    # run knot
    knotd -v -c /etc/knot/knot.conf
else
    # run passed arguments
    exec "$@"
fi
