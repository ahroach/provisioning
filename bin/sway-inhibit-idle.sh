#!/bin/bash

swaymsg inhibit_idle open
echo "Sway idle inhibited. Press any key or close this terminal to re-enable idle."
read -n 1
swaymsg inhibit_idle none

