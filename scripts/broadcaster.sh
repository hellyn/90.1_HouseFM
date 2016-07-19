# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# INSTALL BATMAN SOFTWARE
#
sudo apt-get install -y batctl iw screen

# add the batman-adv module to be started on boot
sudo sed -i '$a batman-adv' /etc/modules
sudo modprobe batman-adv

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