#!/bin/bash

USER=`(whoami)`

## The basics
sudo apt-get install vim-gtk3 git unzip p7zip-full wget xxd screen mosh brightnessctl links
sudo usermod -aG dialout $USER

## Sway window manager
sudo apt-get install sakura sway swaylock swayidle i3status zenity jq suckless-tools
mkdir -p ~/.config/sway
cp ../config/sway.config ~/.config/sway/config
mkdir -p ~/.config/sakura
cp ../config/sakura.conf ~/.config/sakura/sakura.conf

## Networking
sudo apt-get install net-tools nmap
# sudo apt-get install wireshark
# sudo groupadd wireshark
# sudo usermod -aG wireshark $USER

## Python
sudo apt-get install ipython3

## libvirt virtualization
# sudo apt-get install virt-manager

## VirtualBox virtualization
# sudo apt-get install virtualbox

## docker virtualization
# sudo apt-get install docker.io
# sudo groupadd docker
# sudo usermod -aG docker $USER

## Hardware
# sudo apt-get install sigrok pulseview openocd

## Binary analysis
# git clone --depth 1 https://github.com/radareorg/radare2.git
# pushd radare2/sys
# sudo ./install.sh
# popd
# sudo rm -rf radare2
# sudo apt-get install openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre openjdk-11-jre-headless
# wget -r -A "*.zip" -l 1 -O ghidra-latest.zip https://www.ghidra-sre.org
# sudo unzip ghidra-latest.zip -d /usr/local
# sudo ln -s /usr/local/ghidra/ghidraRun /usr/local/bin/ghidra
# rm ghidra-latest.zip

## Vulnerability testing
# sudo docker pull metasploitframework/metasploit-framework
# sudo docker pull mikesplain/openvas-docker

