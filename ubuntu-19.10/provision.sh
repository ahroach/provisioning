#!/bin/bash

USER=`(whoami)`

## The basics
sudo apt-get install vim-gtk3 git unzip p7zip-full wget xxd screen mosh brightnessctl links dos2unix
sudo usermod -aG dialout $USER
sudo usermod -aG video $USER
# Install hexdiff
git clone https://github.com/ahroach/hexdiff
pushd hexdiff
gcc -o hexdiff hexdiff.c
sudo cp hexdiff /usr/local/bin
popd
rm -rf hexdiff
# Install binexplore
git clone https://github.com/ahroach/binexplore
pushd binexplore
sudo mkdir -p /usr/lib/python3/dist-packages/binexplore/
sudo cp * /usr/lib/python3/dist-packages/binexplore/
popd
rm -rf binexplore
# Install diffcount
git clone https://github.com/ahroach/diffcount
pushd diffcount
gcc -mpopcnt -O3 -o diffcount diffcount.c
sudo cp diffcount /usr/local/bin
popd
rm -rf diffcount
# Install carve
sudo cp ../bin/carve /usr/local/bin

## Sway window manager
sudo apt-get install sakura sway swaylock swayidle i3status zenity jq suckless-tools
mkdir -p ~/.config/sway
cp ../config/sway.config ~/.config/sway/config
mkdir -p ~/.config/sakura
cp ../config/sakura.conf ~/.config/sakura/sakura.conf

## Networking
sudo apt-get install net-tools nmap netcat-openbsd netcat-traditional
# sudo apt-get install wireshark
# sudo groupadd wireshark
# sudo usermod -aG wireshark $USER

## Python
sudo apt-get install ipython3 python3-numpy python3-scipy python3-matplotlib

## libvirt virtualization
# sudo apt-get install virt-manager
# sudo usermod -aG libvirt $USER
# sudo usermod -aG libvirt-qemu $USER

## VirtualBox virtualization
# sudo apt-get install virtualbox

## docker virtualization
# sudo apt-get install docker.io
# sudo groupadd docker
# sudo usermod -aG docker $USER

## Hardware
# sudo apt-get install sigrok pulseview putty gtkterm openocd urjtag flashrom can-utils 

## AVR
# sudo apt-get install avr-libc gcc-avr avrdude gdb-avr

## Binary analysis
# sudo apt-get install gdb gdbserver edb-debugger elfutils 
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

