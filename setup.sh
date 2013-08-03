#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git-core
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
git clone https://github.com/startup-class/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

# install R
sudo add-apt-repository -y ppa:marutter/rrutter
sudo apt-get update
sudo apt-get install -y r-base

# install shiny package in R
sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

# install shiny server by node manager npm
sudo npm install -g shiny-server

# Create a system account to run Shiny apps
sudo useradd -r shiny
# Create a root directory for your website
sudo mkdir -p /var/shiny-server/www
# Create a directory for application logs
sudo mkdir -p /var/shiny-server/log

# copy shiny app to specific dir
sudo cp -R ~/accent /var/shiny-server/www/

# start shiny server
#sudo shiny-server


# install R-server
sudo apt-get install gdebi-core
sudo apt-get install libapparmor1  # Required only for Ubuntu, not Debian
wget http://download2.rstudio.org/rstudio-server-0.97.551-amd64.deb
sudo gdebi rstudio-server-0.97.551-amd64.deb
