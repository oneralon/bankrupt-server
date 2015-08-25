# Bankrupt Server #

## Install system packages ##

## Install Node 0.12 ##
```
#!bash
wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
tar xvzf node-v0.12.7.tar.gz
cd node-v0.12.7
sudo apt-get install gcc g++ make
./configure
sudo make install
```

## Install Mongo 3.0 ##
1. Install package:
```
#!bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | \
      sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```
2. Configurate replicaset in `/etc/mongod.conf`:
```
replSet=rs0
oplogSize=1024
```
3. Restart service: `sudo service mongod restart`
4. Initiate replica set from console `mongo`:
```
> use admin
> rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: '127.0.0.1:27017' }] })
> rs.status()
```

## Install Oracle Java 8 ##
```
#!bash
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo update-java-alternatives -s java-8-oracle
sudo echo "JAVA_HOME=$(dirname $(readlink -e $(which java)))" >> /etc/environment
```

## Install ElasticSearch ##
1. Install and start service:
```
#!bash
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.deb
sudo dpkg -i elasticsearch-1.7.1.deb
sudo service elasticsearch start
```
2. Install plugins, set replica and restart:
```
#!bash
export ES_HOME=/usr/share/elasticsearch
$ES_HOME/bin/plugin --install elasticsearch/elasticsearch-mapper-attachments/2.7.0
$ES_HOME/bin/plugin --install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.5
sudo service elasticsearch restart
curl -XPUT "localhost:9200/_river/mongodb/_meta" -d '{
  "type": "mongodb",
  "mongodb": {
    "servers": [
      { "host": "127.0.0.1", "port": 27017 }
    ],
    "options": {
      "secondary_read_preference": true
    },
    "db": "bankrot-parser",
    "collection": "lots", 
    "gridfs": false
  },
  "index": {
    "name": "lots",
    "type": "lot"
  }
}'
sudo service elasticsearch restart
```

## Run server ##
```
#!bash
grunt production
```