mongoose    = require 'mongoose'

config =
  host: 'localhost'
  port: 27017
  database: 'bankrot-parser'
  salt: 'keyboard cat'

unless mongoose.connection.readyState
  mongoose.connect "mongodb://#{config.host}:#{config.port}/#{config.database}"

module.exports = config
