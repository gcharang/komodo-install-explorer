# Install a Block Explorer for a Komodo Smart Chain

This repository simply modifies Decker's script from https://github.com/DeckerSU/komodo-explorers-install to work for a single Smart Chain

## Instructions

### Setup Smart Chain

Either create a new Smart Chain or launch an existing one using its launch parameters. Then shutdown the daemon using the `stop` command.

Example:

```bash
./komodo-cli -ac_name=SMARTCHAINNAME stop
```

The above step creates the '.conf' file for the Smart Chain at `$HOME/.komodo/SMARTCHAINNAME/SMARTCHAINNAME.conf` which will be modified and made use of by the explorer installation script.

### Explorer installation

Clone this repository in your home directory and navigate into it

```bash
cd ~
git clone https://github.com/gcharang/komodo-install-explorer
cd komodo-install-explorer
```

Run the script: https://github.com/gcharang/komodo-install-explorer/blob/master/setup-explorer-directory.sh
This script installs dependencies and prepares the directory for installing the explorer

```bash
./setup-explorer-directory.sh
```

It should create a subdirectory named `node_modules`

Now run the script: https://github.com/gcharang/komodo-install-explorer/blob/master/install-assetchain-explorer.sh with the Smart Chain's name as the argument

```bash
./install-assetchain-explorer.sh SMARTCHAINNAME
```

This will create a new sub directory named `SMARTCHAINNAME-explorer` and a script named `SMARTCHAINNAME-explorer-start.sh`
It also adds data to a file called `SMARTCHAINNAME-webaccess` with the Smart Chain's name and the url to access the explorer from the internet.

Start the Smart Chain with its launch parameters and execute the script `SMARTCHAINNAME-explorer-start.sh` when you want to start the explorer

**Note:** Use the `noweb` option like so: `./install-assetchain-explorer.sh SMARTCHAINNAME noweb` to stop the script from prompting you to open the port for accessing the explorer through the internet; i.e., explorer will only be accessible on the local system

**Note:** When launching the Smart Chain for the first time after installing the explorer, add the `-reindex` parameter to its launch parameters.

### Adding another Smart Chain's explorer and running it at the same time

You can use the `./install-assetchain-explorer.sh SMARTCHAINNAME` command to create explorers for as many Smart Chains as you want, just by changing the `SMARTCHAINNAME`

You can also run them one at a time or all together at the same time depending on your needs.

The only problem is when the ports of two different Smart Chains conflict with each other.

In that case, if you wish to run them at the same time, modify the `install-assetchain-explorer.sh` script to have fixed port values that are all distinct and different from the other Smart Chain's ports. Lets say the Smart Chain's name is `SMARTCHAINNAME1`, then delete the sub directory named `SMARTCHAINNAME1-explorer` and the script named `SMARTCHAINNAME1-explorer-start.sh` and run the modified `install-assetchain-explorer.sh` with its name again:

```bash
install-assetchain-explorer.sh SMARTCHAINNAME1
```
