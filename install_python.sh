#!/bin/bash
set -e
if [[ $1 != http?(s)://*.tar.* ]]; then
    echo "Invalid URL"
    exit 2
fi
echo "Apt update"
sudo apt-get update > /dev/null
echo "Install requirements"
apt list --installed | sed -e "s/\/.*//g" > tmp.txt
INSTALLS=$(grep -vf tmp.txt reqs.txt | tr "\n" " ")
sudo apt-get install $INSTALLS -y > /dev/null
sudo apt-mark auto $INSTALLS
echo "Downloading and extracting Python"
wget -O Python.tar.xz $1
tar xf ./Python.tar.xz
cd Python-*/
echo "Configuring"
./configure --enable-optimizations
CORECOUNT=$(grep -c ^processor /proc/cpuinfo)
echo "Building"
make -j $CORECOUNT
echo "Installing"
sudo make altinstall -j $CORECOUNT
echo "Cleaning up"
cd ..
rm Python.tar.xz
sudo rm -r Python
echo "Removing build requirements"
sudo apt-get autoremove > /dev/null
sudo apt-get clean > /dev/null
echo "Done!"
