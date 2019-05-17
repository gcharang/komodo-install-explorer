# Install a Block Explorer for a Komodo Asset Chain

This repository simply modifies @Decker's script from https://github.com/DeckerSU/komodo-explorers-install to work for a single Asset Chain

## Instructions

### Setup Assetchain

Either create a new asset chain or launch an existing one using its launch parameters. Then shutdown the daemon using the `stop` command.

Example:

```bash
./komodo-cli -ac_name=ASSETCHAINNAME stop
```

The above step creates the '.conf' file for the assetchain at `$HOME/.komodo/ASSETCHAINNAME/ASSETCHAINNAME.conf` which will be modified and made use of by the explorer installation script.

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

Now run the script: https://github.com/gcharang/komodo-install-explorer/blob/master/install-assetchain-explorer.sh with the assetchain's name as the argument

```bash
./install-assetchain-explorer.sh ASSETCHAINNAME
```

This will create a new sub directory named `ASSETCHAINNAME-explorer` and a script named `ASSETCHAINNAME-explorer-start.sh`
It also adds a line to a file called `webaccess` with the assetchain's name and the url to access the explorer from anywhere else.

Execute the script `ASSETCHAINNAME-explorer-start.sh` when you want to start the explorer
