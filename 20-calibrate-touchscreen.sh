#!/bin/bash

# Install dependances for xorg_calibrator
sudo xbps-install -y libX11-devel libXft-devel libXi-devel

git clone https://github.com/ivan-matveev/xorg_calibrator.git
cd ./xorg_calibrator || exit
make

# Run touchscreen calibration for Panasonic CF-U1
./xorg_calibrator device_name="Fujitsu Component USB Touch Panel" output_filename="/usr/share/X11/xorg.conf.d/99-calibration.conf"