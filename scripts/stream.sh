# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SOFTWARE INSTALL
#
sudo apt-get -y --no-install-recommends install build-essential devscripts autotools-dev fakeroot dpkg-dev debhelper autotools-dev dh-make quilt ccache libsamplerate0-dev libpulse-dev libaudio-dev lame libjack-jackd2-dev libasound2-dev libtwolame-dev libfaad-dev libflac-dev libmp4v2-dev libshout3-dev libmp3lame-dev screen

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# INSTALL DARKICE MP3 STREAMING SERVER
#
cd /home/ccrma/little-nets
mkdir darkice-src && cd darkice-src
mkdir src && cd src/
apt-get source darkice
cd darkice-1.0/debian
rm rules
wget http://www.t3node.com/fileadmin/user_upload/linux/rules
sudo chmod +x rules
#debchange -v 1.0-999~mp3+1
#darkice (1.0-999~mp3+1) UNRELEASED; urgency=low

#  * New build with mp3 support

# --  <pi@raspberrypi>  Sat, 11 Aug 2012 13:35:06 +0000
cd ..
dpkg-buildpackage -rfakeroot -uc -b
sudo dpkg -i /home/ccrma/little-nets/darkice-src/src/darkice_1.0-999~mp3+1_armhf.deb
sudo cp /home/ccrma/little-nets/off-the-grid/scripts/darkice.cfg /etc/
sudo aptitude install -y icecast2

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# INSTALL BATMAN SOFTWARE
#
sudo apt-get install -y batctl iw

# add the batman-adv module to be started on boot
sudo sed -i '$a batman-adv' /etc/modules
sudo modprobe batman-adv

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# CREATE VIRTUAL ALSA INTERFACE
#
# add the snd-aloop module to be started on boot
sudo sed -i '$a snd-aloop' /etc/modules
sudo modprobe snd-aloop
sudo cp /home/ccrma/little-nets/off-the-grid/scripts/asoundrc $HOME/.asoundrc
alsa_in -j cloop -dcloop &
alsa_out -j ploop -dploop &
sudo cp /home/ccrma/little-nets/off-the-grid/scripts/loop2jack.sh /usr/local/bin/loop2jack

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# NETWORK CONFIGURATION
#
# modify the network interface config file
sudo python scripts/configure_network_interfaces.py

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# CREATE STARTUP SCRIPT
#
# copy startup script to init.d
# subnodes script configures and starts mesh point on boot
sudo cp scripts/little-nets.sh /etc/init.d/little-nets
sudo chmod 755 /etc/init.d/little-nets
sudo update-rc.d little-nets defaults
sudo /etc/init.d/little-nets restart
