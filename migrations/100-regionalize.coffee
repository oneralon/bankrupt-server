require '../models/trade'
regionize = require '../helpers/regionize'
mongoose  = require 'mongoose'
Sync = require 'sync'
config =
  host: 'localhost'
  port: 27017
  database: 'test-bankrot-parser'
  salt: 'keyboard cat'
unless mongoose.connection.readyState
  mongoose.connect "mongodb://#{config.host}:#{config.port}/#{config.database}"

Trade = mongoose.model 'Trade'

save = (item, cb) ->
  item.save (err, info) ->
    cb err if err?
    cb null, info

Trade.find {region: 'Не определен'}, (err, trades) =>
  console.log trades.length
  Sync =>
    try
      for trade in trades
        trade.region = regionize(trade)
        save.sync null, trade
        console.log trade.region
      console.log 'ok'
      process.exit(0)
    catch e
      console.log err
