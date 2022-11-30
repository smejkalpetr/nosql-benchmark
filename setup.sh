#!/bin/bash

echo "[INFO] Starting..."
echo "[INFO] Installing requirements and setting up the venv..."

# macOS
# brew install python3
# brew install virtualenv
brew install mvn
brew install docker

# Linux
# apt-get install -y python3-pip
# pip3 install virtualenv 
# apt-get install -y docker
# apt-get install -y mvn

# virtualenv venv
# source venv/bin/activate

# clone YCSB & build it
git clone https://github.com/brianfrankcooper/YCSB.git
cd YCSB
mvn -pl site.ycsb:redis-binding -am clean package
cd ../

echo "[INFO] Done installing requirements."

if [ $# -eq 0 ];
then
    echo "[INFO] The benchmark of all three types of databases is starting..."
    chmod +x ./mongodb/setup.sh ./cassandra/setup.sh ./redis/setup.sh
    ./mongodb/setup.sh
    ./cassandra/setup.sh
    ./redis/setup.sh
elif [ $# -gt 2 ];
then
    echo "$0: [INFO] Too many arguments: $@"
    exit 1
else
    if [  "$1" == "mongodb" ];
    then
        # mongodb setup code here
        chmod +x ./mongodb/setup.sh
        ./mongodb/setup.sh
    elif [  "$1" == "cassandra" ];
    then
        # cassandra setup code here
        chmod +x ./cassandra/setup.sh
        ./cassandra/setup.sh
    elif [  "$1" == "redis" ];
    then
        # redis setup code here
        chmod +x ./redis/setup.sh
        ./redis/setup.sh
    else
        echo "[INFO] Wrong argument."
    fi
fi

echo "[INFO] Cleaning..."
rm -rf YCSB
echo "[INFO] Cleaning done."

echo "[INFO] Finished."
