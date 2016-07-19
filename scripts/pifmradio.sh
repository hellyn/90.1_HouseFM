#!/bin/bash
# remember to run: sudo chmod +x pifmradio.sh
# add to rc.updates ./pifmradio.sh & (maybe? just get it to boot on startup. see subnodes.sh)
sox -v .9 -t mp3 http://localhost/raspi -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo ~/off-the-grid/PirateRadio/pifm - 90.1