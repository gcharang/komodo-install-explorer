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

\. $HOME/.komodo/$i/$i.conf

rpcport=$rpcport
zmqport=$((rpcport+2))
webport=$((rpcport+3))

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

echo -e "$STEP_START[ * ]$STEP_END Enter your sudo password so that webport: $webport can be opened"

sudo ufw allow $webport

echo -e "$STEP_START[ * ]$STEP_END Installing explorer for $i"

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
          "rpcuser": $rpcuser,
          "rpcpassword": $rpcpassword,
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
cd $i-explorer
nvm use v4; ./node_modules/bitcore-node-komodo/bin/bitcore-node start
EOF
chmod +x $i-explorer-start.sh

ip = $(curl ifconfig.me)

echo -e "$STEP_START[ * ]$STEP_END Execute $i-explorer-start.sh to start the explorer"
echo -e "$STEP_START[ * ]$STEP_END Visit http://$ip:$webport from another computer to access the explorer"

