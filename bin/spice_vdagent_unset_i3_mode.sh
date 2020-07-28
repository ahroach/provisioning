#!/bin/bash

# Undo the actions performed by the set_i3_mode script, then restart the
# relevant systemd services

OVERRIDE_DIR=/run/systemd/system/spice-vdagentd.service.d/

if [ $(id -u) -ne 0 ]
then
        echo "This script must be run as root."
        exit 1
fi

killall spice-vdagent
rm $OVERRIDE_DIR/override.conf
systemctl daemon-reload
systemctl restart spice-vdagentd.service
systemctl restart spice-vdagent.service

