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
FILENAME=$(basename $1 | sed "s/.......$//") # remove last 7 characters to get rid of the extension
wget -qO- $1 | tar xJ
cd $FILENAME
echo "Configuring"
./configure --enable-optimizations > python.log 2>&1
CORECOUNT=$(grep -c ^processor /proc/cpuinfo)
echo "Building"
make -j $CORECOUNT >> python.log 2>&1
echo "Installing"
sudo make altinstall -j $CORECOUNT >> python.log 2>&1
echo "Cleaning up"
cd ..
rm tmp.txt
rm -r $FILENAME
echo "Removing build requirements"
sudo apt-get autoremove > /dev/null
sudo apt-get clean > /dev/null
echo "Done!"
