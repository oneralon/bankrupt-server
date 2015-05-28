cluster = require 'cluster'
path    = require 'path'
cCPUs   = require('os').cpus().length

if cluster.isMaster
  cluster.settings.exec = path.join __dirname, 'server.coffee'

  cluster.on 'online', () ->
    console.log 'Worker started'

  for i in [0..cCPUs]
    cluster.fork()

