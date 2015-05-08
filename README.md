# Bankrupt server #
## 1. Installation ##
### Install database ###
```
#!bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

### Install node.js ###
Download node@0.10.26 from https://github.com/joyent/node/archive/v0.10.26-release.zip. Extract and execute:
```
#!bash
./configure
sudo make install
```

### Install node packages ###
```
#!bash
sudo npm install -g grunt
sudo npm install -g coffee-script
npm install
```

## 2. Start parsing ##
```
#!bash
cd bankrupt_parser_folder
coffee index.coffee
```

## 3. Run server ##
```
#!bash
cd bankrupt_server_folder
grunt production
```
