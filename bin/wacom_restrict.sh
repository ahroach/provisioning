#!/bin/bash

DISPLAY_NAME=DisplayPort-1
STYLUS_ID=`xinput | grep "Pen stylus" | cut -f 2 | cut -c 4-5`
xinput map-to-output $STYLUS_ID $DISPLAY_NAME


