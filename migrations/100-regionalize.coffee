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

Trade.find {}, (err, trades) =>
  console.log trades.length
  Sync =>
    try
      i = 0
      for trade in trades
        trade.region = regionize(trade)
        trade.save.sync trade
        res = Lot.update.sync Lot, {trade: trade}, {region: trade.region}
        console.log "OK #{trade.region}"
        console.log res
        i++
      console.log 'Trades OK'
      process.exit 0
    catch e
      console.log err
      process.exit 1

