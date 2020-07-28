#!/bin/bash

# Set up spice-vdagent to allow clipboard sharing in i3.
# spice-vdagentd must run with the -X option to work with i3, since i3
# lacks sufficient logind integration for these features to work otherwise.
# Use a systemd override file to add the -X option to the
# spice-vdagentd.service, then run spice-vdagent.

OVERRIDE_DIR=/run/systemd/system/spice-vdagentd.service.d/

if [ $(id -u) -ne 0 ]
then
        echo "This script must be run as root."
        exit 1
fi

mkdir -p $OVERRIDE_DIR
cat > $OVERRIDE_DIR/override.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/sbin/spice-vdagentd -X \$SPICE_VDAGENTD_EXTRA_ARGS
EOF
systemctl daemon-reload
systemctl restart spice-vdagentd.service
spice-vdagent

