#!/bin/sh

set -eux

/usr/local/bin/tox-bootstrapd --config /etc/tox-bootstrapd.conf --log-backend stdout --foreground &
/usr/local/bin/websockify -l 0.0.0.0:"$PORT" -t 127.0.0.1:33445
