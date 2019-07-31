#!/bin/bash
set -e
if [[ $1 != http?(s)://*.tar.* ]]; then
    echo "Invalid URL"
    exit 2
fi
echo "Install requirements"
apt list --installed 2>/dev/null | sed -e "s/\/.*//g" > tmp.txt
INSTALLS=$(grep -vf tmp.txt reqs.txt | tr "\n" " ")
if [ ${#INSTALLS} -gt 1 ]; then
    echo "Apt update"
    sudo apt-get update > /dev/null
    sudo apt-get install $INSTALLS -y # > /dev/null
    sudo apt-mark auto $INSTALLS
else
    echo "You have all the requirements; awesome!"
fi
echo "Downloading and extracting Python"
wget -O Python.tar.xz $1
tar xf ./Python.tar.xz
cd Python-*/
echo "Configuring"
./configure --enable-optimizations > python.log 2>&1
CORECOUNT=$(grep -c ^processor /proc/cpuinfo)
echo "Building"
make -j $CORECOUNT >> python.log 2>&1
echo "Installing"
sudo make altinstall -j $CORECOUNT >> python.log 2>&1
echo "Cleaning up"
cd ..
rm Python.tar.xz tmp.txt
rm -r Python-*/
echo "Removing build requirements"
sudo apt-get autoremove > /dev/null
sudo apt-get clean > /dev/null
echo "Done!"
