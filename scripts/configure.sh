# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SOFTWARE INSTALL
#
# update the packages (may take a long time)
#sudo sh -c "echo 'deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi' >> /etc/apt/sources.list"
#sudo rpi-update && sudo apt-get -y update
#&& sudo apt-get -y upgrade
sudo apt-get -y --no-install-recommends install build-essential devscripts autotools-dev fakeroot dpkg-dev debhelper autotools-dev dh-make quilt ccache libsamplerate0-dev libpulse-dev libaudio-dev lame libjack-jackd2-dev libasound2-dev libtwolame-dev libfaad-dev libflac-dev libmp4v2-dev libshout3-dev libmp3lame-dev
#mkdir little-nets && cd little-nets

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# GRAB THE REPO
#
#git clone https://github.com/chootka/off-the-grid.git
#cd off-the-grid
#git checkout pd && git submodule init

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# INSTALL DARKICE MP3 STREAMINGI SERVER
#
cd ..
mkdir darkice-src && cd darkice-src
mkdir src && cd src/
apt-get source darkice
cd darkice-1.0/debian
rm rules
wget http://www.t3node.com/fileadmin/user_upload/linux/rules
sudo chmod +x rules
cd ..
#dpkg-buildpackage -rfakeroot -uc -b
#sudo dpkg -i ../darkice_1.0-999~mp3+1_armhf.deb
#sudo cp ../../off-the-grid/scripts/darkice.cfg /etc/
sudo aptitude install icecast2

# install prerequisite software
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
sudo cp ../../off-the-grid/scripts/asoundrc $HOME/.asoundrc
alsa_in -j cloop -dcloop &
alsa_out -j ploop -dploop &
sudo cp ../../off-the-grid/scripts/loop2jack /usr/local/bin/loop2jack
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
