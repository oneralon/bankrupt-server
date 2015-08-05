require '../models/trade'
require '../models/lot'

regionize = require '../helpers/regionize'
mongoose  = require 'mongoose'
Sync = require 'sync'
config =
  host: 'localhost'
  port: 27017
  database: 'bankrot-parser'
  salt: 'keyboard cat'
unless mongoose.connection.readyState
  mongoose.connect "mongodb://#{config.host}:#{config.port}/#{config.database}"

Trade = mongoose.model 'Trade'
Lot = mongoose.model 'Lot'

save = (trade, cb) ->
  trade.save (err, info) =>
    cb err if err?
    Lot.update {trade: trade}, {$set: {region: trade.region}}, (err, res) =>
      cb err if err?
      cb null, res

Trade.find {}, (err, trades) =>
  console.log trades.length
  Sync =>
    try
      for trade in trades
        trade.region = regionize(trade)
        res = save.sync null, trade
        console.log res
      console.log 'Trades OK'
      process.exit 0
    catch e
      console.log err
      process.exit 1

