#!/bin/sh
set -e
sudo apt update 
sudo apt -y install autoconf-archive awscli libcmocka0 libcmocka-dev procps iproute2 build-essential git pkg-config gcc libtool automake libssl-dev uthash-dev autoconf doxygen libgcrypt-dev libjson-c-dev libcurl4-gnutls-dev uuid-dev pandoc libglib2.0-dev libsqlite3-dev libyaml-dev python-wxtools python3-pip
pip3 install PyPubSub
wget http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2022.02.11.tar.xz -P $PWD/
tar -xf $PWD/autoconf-archive-2022.02.11.tar.xz -C $PWD/
git clone https://github.com/tpm2-software/tpm2-tss.git $PWD/tpm2-tss
cd $PWD/tpm2-tss/
git checkout 3.2.0
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/tpm2-tss/
cd $PWD/tpm2-tss/

./bootstrap
./configure --with-udevrulesdir=/etc/udev/rules.d
make -j$(nproc) 
sudo make install 
sudo ldconfig
cd ..
git clone https://github.com/tpm2-software/tpm2-tools.git $PWD/tpm2-tools/
cd $PWD/tpm2-tools/
git checkout 5.2
./bootstrap
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/tpm2-tools/
cd $PWD/tpm2-tools/
./bootstrap
./configure
make -j$(nproc) 
sudo make install 
sudo ldconfig
cd ..
git clone https://github.com/tpm2-software/tpm2-abrmd $PWD/tpm2-abrmd/
cd $PWD/tpm2-abrmd/
git checkout 2.4.1
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/tpm2-abrmd/
cd $PWD/tpm2-abrmd/
./bootstrap 
./configure --with-dbuspolicydir=/etc/dbus-1/system.d
make -j$(nproc) 
sudo make install 
sudo ldconfig
cd ..
sudo useradd --system --user-group tss || true
sudo pkill -HUP dbus-daemon
sudo systemctl daemon-reload
git clone https://github.com/tpm2-software/tpm2-tss-engine $PWD/tpm2-tss-engine/
cd $PWD/tpm2-tss-engine/
git checkout v1.1.0
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/tpm2-tss-engine/
cd $PWD/tpm2-tss-engine/
./bootstrap 
./configure 
make -j$(nproc) 
sudo make install 
sudo ldconfig
cd ..
git clone https://github.com/tpm2-software/tpm2-pkcs11 $PWD/tpm2-pkcs11/
cd $PWD/tpm2-pkcs11/
git checkout 1.6.0
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/tpm2-pkcs11/
cd $PWD/tpm2-pkcs11/
./bootstrap
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..
pip3 install pyyaml
pip3 install pyasn1-modules
python3 -m pip install git+https://github.com/tpm2-software/tpm2-pytss.git
sudo apt install libpcsclite-dev
git clone https://github.com/OpenSC/OpenSC $PWD/OpenSC/
cd $PWD/OpenSC/
git checkout 0.21.0
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/OpenSC/
cd $PWD/OpenSC/
./bootstrap
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..
git clone https://github.com/OpenSC/libp11.git $PWD/libp11/
cd $PWD/libp11/
git checkout libp11-0.4.11
cd ..
sudo cp -r $PWD/autoconf-archive-2022.02.11/m4 $PWD/libp11/
cd $PWD/libp11/
./bootstrap
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..
cd $PWD/tpm2-pkcs11/tools/
pip install .
cd ../..
sudo reboot
