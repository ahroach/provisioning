#!/bin/bash

# Following:
# https://askubuntu.com/questions/906137/seriously-dconf-gconf-gsettings-how-do-i-save-my-terminal-settings

gprofile=$(gsettings get org.gnome.Terminal.ProfilesList default)
gprofile=${gprofile:1:-1}
gschema=org.gnome.Terminal.Legacy.Profile
gpath=/org/gnome/terminal/legacy/profiles:/:${gprofile}/
gsettings list-recursively ${gschema}:${gpath}

