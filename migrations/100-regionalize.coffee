require '../models/trade'
require '../models/lot'

regionize = require '../helpers/regionize'
mongoose  = require 'mongoose'
ObjectID  = mongoose.Types.ObjectId
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
    cb null, info

update = (trade, cb) ->
  mongoose.connection.collection('lots').update {trade: trade}, {$set: {region: trade.region}}, (err) =>
    cb err if err?  
    cb()

Trade.find {}, '_id region', (err, trades) =>
  console.log trades.length
  Sync =>
    try
      for trade in trades
        trade.region = regionize(trade)
        save.sync null, trade
        update.sync null, trade
        console.log trade.region
      console.log 'Trades OK'
      process.exit 0
    catch e
      console.log err
      process.exit 1

