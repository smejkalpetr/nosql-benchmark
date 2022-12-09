#!/bin/bash

sudo apt install git -y
sudo apt install python2 -y
sudo apt install python3-virtualenv -y
sudo apt install maven -y
sudo apt install python2-pip-whl -y
sudo apt install python2-setuptools-whl -y
sudo apt install default-jre -y

# docker
sudo apt-get update -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# docker-compose
sudo apt update
sudo apt upgrade

sudo apt install docker-compose -y

# docker permissions

sudo chmod +x /usr/bin/docker
sudo chgrp docker /usr/bin/docker
sudo chmod 750 /usr/bin/docker