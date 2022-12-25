#!/bin/sh

# Shell commands to quick setup on droplet

echo "Updating Packages"
sudo apt update
sudo apt upgrade -y
echo "................................"

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
echo "................................"

echo "Installing node and enabling yarn"
nvm install --lts
echo "Node version"
node -v

corepack enable
echo "Yarn version"
yarn -v
echo "................................"

echo "Installing pm2"
yarn global add pm2
echo "................................"

echo "Installing mongodb and nginx"
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update

# Temporary fix for mongodb
echo "deb http://security.ubuntu.com/ubuntu impish-security main" | sudo tee /etc/apt/sources.list.d/impish-security.list
sudo apt-get update
sudo apt-get install libssl1.1

sudo apt install mongodb-org nginx -y
echo "................................"

echo "Cloning Cezerin"
mkdir /var/www
cd /var/www
git clone https://github.com/Cezerin2/Cezerin2.git
echo "................................"

echo "Updating config files"
cd Cezerin2

echo "................................"

echo "Building Cezerin"
echo "Installing Packages"
yarn
echo "................................"

echo "Building theme file"
yarn theme:compile
echo "................................"

echo "Adding theme file"
yarn add ./theme
echo "................................"

echo "Building Cezerin"
yarn build
echo "................................"

echo "Running Cezerin setup"
yarn setup
echo "................................"

echo "Starting Cezerin"
pm2 start process.json
pm2 status

echo "To run node commands, run: source ~/.bashrc"
echo "To restart bash for nvm"

echo "................................"

echo "Thank you for using Cezerin"

echo "If you have any quetions, post them at issues section,"
echo "https://github.com/Cezerin2/Cezerin2/issues"
