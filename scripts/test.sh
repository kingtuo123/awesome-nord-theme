#!/bin/bash

# /etc/udev/rules.d/10-usb.rules
# KERNEL=="sd*", SUBSYSTEM=="block", RUN+="/usr/bin/su -c /home/king/test.sh king"

export `cat /tmp/my-dbus`
awesome-client "require('widgets.volume'):toggle()"
