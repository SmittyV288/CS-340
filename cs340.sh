#!/bin/bash

# Install packages
sudo apt install -y python3-pip
python3 -m pip install pymongo
pip install jupyter-dash
pip install dash-leaflet==0.1.9
pip install dash==2.8.1
pip install pandas==1.4.2

cd ~/Downloads

# Install mongoDB packages
sudo dpkg -i mongodb-org-server_7.0.2_amd64.deb
sudo dpkg -i mongodb-mongosh_2.0.1_amd64.deb
sudo dpkg -i mongodb-database-tools-ubuntu2204-x86_64-100.8.0.deb

sudo mkdir -p /usr/local/datasets
cd datasets
sudo mv * /usr/local/datasets
cd ~/Downloads/mongo
# move mongodb files
mv mongodb-env ~/Desktop
mv mongoshrc.js ~/.mongoshrc

# Run source mongodb env for each terminal
echo 'source ~/Desktop/mongodb-env' >> ~/.bashrc
source ~/.bashrc


# start mongo server
sudo mongod --port 27017 --dbpath /var/lib/mongodb

sleep 5

# start mongosh in new terminal
gnome-terminal -- mongosh << EOF
use admin
db.createUser({user: "root", pwd: "password", roles: [{role: "root", db: "admin"}]})
db.adminCommand({shutdown: 1})
exit
EOF

sudo sed -i 's/#security:/security:\n  authorization: enabled/' /etc/mongod.conf

# start mongo server with auth
gnome-terminal -- base -c "sudo mongod --auth --port 27017 --dbpath /var/lib/mongodb"
