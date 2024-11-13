#!/bin/bash

# /etc/udev/rules.d/10-usb.rules
# KERNEL=="sd*", SUBSYSTEM=="block", RUN+="/usr/bin/su king -c /home/king/test.sh"

export `cat /tmp/my-dbus`
awesome-client "require('widgets.disk'):update()"
