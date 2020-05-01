#!/bin/bash

# Following:
# https://askubuntu.com/questions/906137/seriously-dconf-gconf-gsettings-how-do-i-save-my-terminal-settings

if ! [ -f $1 ]
then
	echo "Must supply file name with saved gsettings"
	exit 1
fi

# Disable menubar by default
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

# Provide other terminal profile settings
gprofile=$(gsettings get org.gnome.Terminal.ProfilesList default)
gprofile=${gprofile:1:-1}
gschema=org.gnome.Terminal.Legacy.Profile
gpath=/org/gnome/terminal/legacy/profiles:/:${gprofile}/        
cut -f2- -d' ' $1 | while read line; do
   key=$(echo $line | cut -f1 -d' ')
   value=$(echo $line | cut -f2- -d' ')
   # Used for dry-run
   # echo "$key => $value"
   gsettings set ${gschema}:${gpath} $key "$value"
done

