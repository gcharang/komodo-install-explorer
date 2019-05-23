#!/bin/bash

#
# (c) Decker, 2018
#

STEP_START='\e[1;47;42m'
STEP_END='\e[0m'

i=$1

CUR_DIR=$(pwd)
echo "Installing an explorer for $i in the current directory: $CUR_DIR"

echo -e "$STEP_START[ * ]$STEP_END Modifying $i's '.conf' file at $HOME/.komodo/$i/$i.conf"


declare -a kmd_coins=$i

. $HOME/.komodo/$i/$i.conf

rpcport=$rpcport
zmqport=$((rpcport+1))
webport=$((rpcport+2))

rm $HOME/.komodo/$i/$i.conf

mkdir -p $HOME/.komodo/$i
touch $HOME/.komodo/$i/$i.conf
cat <<EOF > $HOME/.komodo/$i/$i.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:$zmqport
zmqpubhashblock=tcp://127.0.0.1:$zmqport
rpcallowip=127.0.0.1
rpcport=$rpcport
rpcuser=$rpcuser
rpcpassword=$rpcpassword
uacomment=bitcore
showmetrics=0
rpcworkqueue=256
EOF

if [ $# -eq 2 ]; then
  if [ "$2" = "noweb" ]; then
    echo "The webport hasn't been opened; To access the explorer through the internet, open the port: $webport by executing the command 'sudo ufw allow $webport' "
  fi  
else  
  echo -e "$STEP_START[ * ]$STEP_END Enter your 'sudo' password so that the webport: $webport can be opened"
  sudo ufw allow $webport
fi


echo -e "$STEP_START[ * ]$STEP_END Installing explorer for $i"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
nvm use v4

$CUR_DIR/node_modules/bitcore-node-komodo/bin/bitcore-node create $i-explorer
cd $i-explorer
$CUR_DIR/node_modules/bitcore-node-komodo/bin/bitcore-node install git+https://git@github.com/DeckerSU/insight-api-komodo git+https://git@github.com/DeckerSU/insight-ui-komodo
cd $CUR_DIR

cat << EOF > $CUR_DIR/$i-explorer/bitcore-node.json
{
  "network": "mainnet",
  "port": $webport,
  "services": [
    "bitcoind",
    "insight-api-komodo",
    "insight-ui-komodo",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "connect": [
        {
          "rpchost": "127.0.0.1",
          "rpcport": $rpcport,
          "rpcuser": "$rpcuser",
          "rpcpassword": "$rpcpassword",
          "zmqpubrawtx": "tcp://127.0.0.1:$zmqport"
        }
      ]
    },
  "insight-api-komodo": {
    "rateLimiterOptions": {
      "whitelist": ["::ffff:127.0.0.1","127.0.0.1"],
      "whitelistLimit": 500000, 
      "whitelistInterval": 3600000 
    }
  }
  }
}

EOF

# creating launch script for explorer
cat << EOF > $CUR_DIR/$i-explorer-start.sh
#!/bin/bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
cd $i-explorer
nvm use v4; ./node_modules/bitcore-node-komodo/bin/bitcore-node start
EOF
chmod +x $i-explorer-start.sh

ip=$(curl ifconfig.me)

echo -e "$STEP_START[ * ]$STEP_END Execute $i-explorer-start.sh to start the explorer"
if [ $# -eq 2 ]; then
  if [ "$2" = "noweb" ]; then
    echo "The webport hasn't been opened; To access the explorer through the internet, open the port: $webport by executing the command 'sudo ufw allow $webport' "
    touch $i-webaccess
    echo "url=http://localhost:$webport" >> $i-webaccess
    echo "webport=$webport" >> $i-webaccess
  fi  
else 
  echo -e "$STEP_START[ * ]$STEP_END Visit http://$ip:$webport from another computer to access the explorer after starting it"
  touch $i-webaccess
  echo "url=http://$ip:$webport" >> $i-webaccess
  echo "webport=$webport" >> $i-webaccess
fi  
echo -e "$STEP_START[ * ]$STEP_END Visit http://localhost:$webport on your computer to access the explorer after starting it"

echo "Patching the installation to display notarization data"

git clone https://github.com/gcharang/explorer-notarized 
cd explorer-notarized
./patch $i

if [ ! -d "$CUR_DIR/explorer-notarized" ]; then
  echo "Cloning the repository cointaining the patch"
  success=0
  count=1
  while [ $success -eq 0 ]; do
    echo "[Try $count] Cloning the explorer installer repository"
    git clone https://github.com/gcharang/explorer-notarized && success=1 || success=0
    sleep 4
    count=$((count+1))
  done
else
  echo "A directory named 'explorer-notarized' already exists; assuming it is cloned from the repo: https://github.com/gcharang/explorer-notarized , trying to patch the explorer using it"
fi

cd explorer-notarized
./patch.sh $i