#!/bin/sh

echo "Raspi-Config steps"
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_vnc 1
sudo raspi-config nonint do_ssh 1

echo "Updating...."
sleep 2

sudo apt-get -qq update
sudo apt-get -qqy upgrade 
sudo apt-get -qqy dist-upgrade
sudo rpi-update

echo "Installing from apt"
sudo apt-get install -qqy mu python-numpy python-wxversion python-wxgtk3.0 python-pyparsing python-cairo libhidapi-libusb0 gnome-schedule python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtserialport python3-pyqt5.qtsvg python3-dev libav-tools ffmpeg

echo "Installing epoptes"
wget -q http://rogerthat.co.uk/Pi/hosts
sudo mv hosts /etc/hosts
sudo apt-get install -qqy epoptes-client
sudo epoptes-client -c

echo "Setting up WiFi"
wget -q http://rogerthat.co.uk/Pi/wpa_supplicant.conf
sudo mv wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
wget -q http://rogerthat.co.uk/Pi/interfaces
sudo mv interfaces /etc/network/interfaces

echo "Installing MOTD"
wget -q http://rogerthat.co.uk/Pi/motd
sudo mv motd /etc/motd

echo "Installing from Pip3"
sudo pip3 -q install guizero twython python-osc explorerhat pibrella piglow requests-oauthlib pyinstaller codebug-i2c-tether codebug-tether --upgrade
sudo pip -q install explorerhat pibrella piglow requests-oauthlib pyinstaller 

echo "Installing Crumble"
wget -q http://redfernelectronics.co.uk/?ddownload=3869 -O crumble_0.25.2_all.deb
sudo dpkg -i crumble_0.25.2_all.deb 
rm crumble_0.25.2_all.deb

echo "Setting Wallpaper"
wget https://raw.githubusercontent.com/Roobinson/edu-image/master/Raspbain-Desktop-Background-1366x768.png
sudo cp Raspbain-Desktop-Background-1366x768.png /usr/share/rpd-wallpaper/smsj.png
sudo cp Raspbain-Desktop-Background-1366x768.png /usr/share/pt-artwork/img/wallpapers/Grid.png
sed -i -e 's/road.jpg/smsj.png/g' .config/pcmanfm/LXDE-pi/desktop-items-0.conf
pcmanfm -w /usr/share/rpd-wallpaper/smsj.png

echo "Setting up Resize"
sudo wget -q https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/cmdline.txt -O /boot/cmdline.txt
sudo wget -O /etc/init.d/resize2fs_once https://github.com/RPi-Distro/pi-gen/raw/dev/stage2/01-sys-tweaks/files/resize2fs_once
sudo chmod +x /etc/init.d/resize2fs_once
sudo systemctl enable resize2fs_once

echo "Complete, ready to halt. Type 'sudo halt' and then shutdown. Else 'sudo reboot' to use immediately."

