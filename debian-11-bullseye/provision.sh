#!/bin/bash

INSTALL_BASICS=true
INSTALL_SWAY=false
INSTALL_I3=true
INSTALL_LAPTOP_TOOLS=false
INSTALL_PRESENTATION_TOOLS=false
INSTALL_NETWORK_ANALYSIS=false
INSTALL_BINARY_ANALYSIS=false
INSTALL_CTF_TOOLS=false
INSTALL_32BIT_SUPPORT=false
INSTALL_LIBVIRT=false
INSTALL_DOCKER=false
INSTALL_DOCKER_SCANNING_IMAGES=false
INSTALL_EMULATION=false
INSTALL_FIRMWARE=false
INSTALL_HARDWARE=false
INSTALL_HARDWARE_CAN=false
INSTALL_HARDWARE_AVR=false
INSTALL_HARDWARE_ESP=false

export DEBIAN_FRONTEND=noninteractive
USER=`(logname)`

if [ $(id -u) -ne 0 ]
then
	echo "This script must be run as root. (Use sudo.)"
	exit 1
fi

apt-get update
if [ $? -ne 0 ]
then
	echo "Apt update failed. Check network connection or for competing apt processes."
	exit 1
fi

apt-get -yq install software-properties-common
add-apt-repository contrib
add-apt-repository non-free

if [ "$INSTALL_BASICS" = true ]
then
	apt-get -yq install vim-gtk3 git unzip p7zip-full xxd screen mosh dos2unix units bless
	apt-get -yq install wget links curl net-tools nmap netcat-openbsd netcat-traditional
	apt-get -yq install build-essential autoconf automake cmake flex bison
	apt-get -yq install libssl-dev
	apt-get -yq install ipython3 python3-pycryptodome python3-numpy python3-matplotlib python3-pip
	apt-get -yq install ufw gufw
	apt-get -yq install pavucontrol pulsemixer
	apt-get -yq install spice-vdagent spice-webdavd
	usermod -aG dialout $USER
	usermod -aG audio $USER
	usermod -aG video $USER
	usermod -aG input $USER
	usermod -aG sudo $USER
	# Install hexdiff
	git clone https://github.com/ahroach/hexdiff
	pushd hexdiff
	gcc -o hexdiff hexdiff.c
	cp hexdiff /usr/local/bin
	popd
	rm -rf hexdiff
	# Install binexplore
	git clone https://github.com/ahroach/binexplore
	pushd binexplore
	mkdir -p /usr/lib/python3/dist-packages/binexplore/
	cp * /usr/lib/python3/dist-packages/binexplore/
	popd
	rm -rf binexplore
	# Install diffcount
	git clone https://github.com/ahroach/diffcount
	pushd diffcount
	gcc -mpopcnt -O3 -o diffcount diffcount.c
	cp diffcount /usr/local/bin
	popd
	rm -rf diffcount
	# Install carve
	cp ../bin/carve /usr/local/bin
fi

if [ "$INSTALL_SWAY" = true ]
then
	# swaylock not available in Bullseye
	apt-get -yq install sakura gnome-terminal sway swayidle wofi i3status zenity jq suckless-tools libglib2.0-bin
	apt-get -yq install qtwayland5
	# Sef default sway config
	mkdir -p /home/$USER/.config/sway
	cp ../config/sway.config /home/$USER/.config/sway/config
	chown $USER:$USER /home/$USER/.config/sway/config
	# Set default sakura config
	mkdir -p /home/$USER/.config/sakura
	cp ../config/sakura.conf /home/$USER/.config/sakura/sakura.conf
	chown $USER:$USER /home/$USER/.config/sakura/sakura.conf
	# Set default gnome-terminal config
	sudo -u $USER ../scripts/set_gnome-terminal_config.sh ../config/gnome-terminal.gsettings
fi

if [ "$INSTALL_I3" = true ]
then
	apt-get -yq install i3 i3lock i3status xautolock
	apt-get -yq install sakura gnome-terminal compton network-manager-gnome zenity jq suckless-tools libglib2.0-bin
	# Set default i3 config
	mkdir -p /home/$USER/.config/i3
	cp ../config/i3.config /home/$USER/.config/i3/config
	chown $USER:$USER /home/$USER/.config/i3/config
	# Set default sakura config
	mkdir -p /home/$USER/.config/sakura
	cp ../config/sakura.conf /home/$USER/.config/sakura/sakura.conf
	chown $USER:$USER /home/$USER/.config/sakura/sakura.conf
	# Set default gnome-terminal config
	sudo -u $USER ../scripts/set_gnome-terminal_config.sh ../config/gnome-terminal.gsettings
	# Provide spice-vdagent scripts
	cp ../bin/spice_vdagent_set_i3_mode.sh /usr/local/bin
	cp ../bin/spice_vdagent_unset_i3_mode.sh /usr/local/bin
	cp ../bin/disable_screen_blank.sh /usr/local/bin
	cp ../bin/enable_screen_blank.sh /usr/local/bin
	cp ../bin/wacom_restrict.sh /usr/local/bin
fi

if [ "$INSTALL_LAPTOP_TOOLS" = true ]
then
	apt-get -yq install laptop-mode-tools rfkill brightnessctl upower powertop
	cat > /etc/udev/rules.d/backlight.rules << EOF
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF
fi

if [ "$INSTALL_PRESENTATION_TOOLS" = true ]
then
	apt-get -yq install cheese guvcview v4l-utils
	apt-get -yq install xournal gromit-mpx
	apt-get -yq install texlive texlive-latex-recommended texlive-latex-extra
	apt-get -yq install inkscape gimp krita
fi

if [ "$INSTALL_NETWORK_ANALYSIS" = true ]
then
	# Install setuid to allow capture by wireshark group members
	echo wireshark-common wireshark-common/install-setuid boolean true | debconf-set-selections
	apt-get -yq install wireshark qtwayland5
	groupadd wireshark
	usermod -aG wireshark $USER
	apt-get -yq install python3-scapy
	apt-get -yq install tcpreplay
fi

if [ "$INSTALL_BINARY_ANALYSIS" = true ]
then
	apt-get -yq install gdb gdbserver edb-debugger elfutils patchelf
	git clone --depth 1 https://github.com/radareorg/radare2.git
	# Install radare2
	pushd radare2
	sys/debian.sh
	dpkg -i radare2_*.deb
	dpkg -i radare2-dev_*.deb
	popd
	rm -rf radare2

	# Install Ghidra
	apt-get -yq install openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre openjdk-11-jre-headless
	# Needed for Github API interaction
	apt-get -yq install curl wget jq
	# Always get the latest version, which should be returned first
	asset_id=`curl -H "Accept: application/vnd.github.v3.raw" \
		-s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases \
		| jq ".[0].assets[0].id"`
	if [ "$asset_id" != "null" ]; then
		wget -q \
		  --header='Accept:application/octet-stream' \
		  https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/assets/$asset_id \
		  -O ghidra-latest.zip
	fi
	unzip ghidra-latest.zip -d /usr/local
	# If there happen to be multiple ghidra installations (there shouldn't), just
	# link to the first one we find
	ghidras=(/usr/local/ghidra*)
	ln -s ${ghidras[0]}/ghidraRun /usr/local/bin/ghidra
	rm ghidra-latest.zip
	# Make things better on Wayland
	echo "_JAVA_AWT_WM_NONREPARENTING=1" >> /etc/environment
fi

if [ "$INSTALL_CTF_TOOLS" = true ]
then
	# Install pwntools
	apt-get -yq install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential 
	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade pwntools

	# Install pwndbg
	apt-get -y install git gdb python3-dev python3-pip python3-setuptools libglib2.0-dev libc6-dbg
	mkdir -p /home/$USER/git
	pushd /home/$USER/git
	sudo -u $USER git clone https://github.com/pwndbg/pwndbg
	cd pwndbg
	./setup.sh
	# Add source manually, since setup.sh won't know correct user
	if ! grep pwndbg /home/$USER/.gdbinit &>/dev/null; then
		echo "source $PWD/gdbinit.py" >> /home/$USER/.gdbinit
	fi
	popd
fi

if [ "$INSTALL_32BIT_SUPPORT" = true ]
then
	apt-get -yq install libc6-i386
fi

if [ "$INSTALL_LIBVIRT" = true ]
then
	apt-get -yq install libvirt0 libvirt-daemon libvirt-daemon-system virt-manager virt-viewer
	groupadd libvirt
	usermod -aG libvirt $USER
	groupadd libvirt-qemu
	usermod -aG libvirt-qemu $USER
fi

if [ "$INSTALL_DOCKER" = true ]
then
	apt-get -yq install docker.io
	groupadd docker
	usermod -aG docker $USER
fi

if [ "$INSTALL_DOCKER_SCANNING_IMAGES" = true ]
then
	docker pull metasploitframework/metasploit-framework
	docker pull mikesplain/openvas
fi

if [ "$INSTALL_EMULATION" = true ]
then
	apt-get -yq install qemu-user qemu-system
	apt-get -yq install libc6-armel-cross libc6-arm64-cross
	apt-get -yq install libgcc-s1-armel-cross libgcc-s1-arm64-cross
	apt-get -yq install gdb-multiarch
fi

if [ "$INSTALL_FIRMWARE" = true ]
then
	apt-get -yq install binwalk squashfs-tools srecord
fi

if [ "$INSTALL_HARDWARE" = true ]
then
	apt-get -yq install sigrok pulseview putty gtkterm python3-serial
	apt-get -yq install openocd urjtag flashrom
fi

if [ "$INSTALL_HARDWARE_CAN" = true ]
then
	apt-get -yq install python3-can can-utils
fi

if [ "$INSTALL_HARDWARE_AVR" = true ]
then
	apt-get -yq install avr-libc gcc-avr avrdude gdb-avr simavr libsimavr-dev
fi

if [ "$INSTALL_HARDWARE_ESP" = true ]
then
	apt-get -yq install esptool
fi

