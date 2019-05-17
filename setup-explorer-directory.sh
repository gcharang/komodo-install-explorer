#!/bin/bash

#
# (c) Decker, 2018
#

STEP_START='\e[1;47;42m'
STEP_END='\e[0m'

CUR_DIR=$(pwd)
echo "Preparing the current directory: $CUR_DIR"
echo "This script needs to be run only once in a directory. It installs dependencies and komodo's flavour of bitcore-node"

echo -e "$STEP_START[ * ]$STEP_END Installing dependencies"
sudo apt --yes install git
sudo apt --yes install build-essential pkg-config libc6-dev libevent-dev m4 g++-multilib autoconf libtool libncurses5-dev unzip git python zlib1g-dev wget bsdmainutils automake libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libdb++-dev ntp ntpdate
sudo apt --yes install libcurl4-gnutls-dev
sudo apt --yes install curl

echo -e "$STEP_START[ * ]$STEP_END Installing NodeJS and Bitcore Node"

# install nodejs and other stuff
sudo apt --yes install libsodium-dev npm
sudo apt --yes install libzmq3-dev

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# switch node setup with nvm
nvm install v4

npm install git+https://git@github.com/DeckerSU/bitcore-node-komodo # npm install bitcore

