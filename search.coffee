express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'
Promise   = require 'promise'

elastic   = require './helpers/elastic'

config = require './config/db'

require './models/trade'
require './models/lot'
require './models/lot_alias'
require './models/tag'
Trade     = mongoose.model 'Trade'
Lot       = mongoose.model 'Lot'
LotAlias  = mongoose.model 'LotAlias'
Tag       = mongoose.model 'Tag'

promises = []

query = Lot.find()

lot_ids = []

promises.push new Promise (resolve, reject) ->
  tradeQuery = {}
  tradeQuery['trade_type'] = $in: ["публичное предложение"]

  mongoose.connection.collection('trades').find tradeQuery, {'lots': 1}, (err, cursor) ->
    cursor.toArray (err, trades) ->
      # console.log 'mongo public ids', trades
      lots = []
      for trade in trades
        lots = lots.concat trade.lots

      console.log lots.length
      # query.where trade: $in: ids
      # Lot.find trade: $in: ids, {'_id': 1}, (err, lots) ->
      public_lots = lots.map (item) -> return item.toString()
      unless _.isEmpty lot_ids
        lot_ids = _.intersection lot_ids, public_lots
      else
        lot_ids = public_lots

      console.log "Mongo found #{public_lots.length}"

      resolve public_lots

text = 'fdnjvj,bkm'
page = 1
perPage = 10000

unless _.isEmpty text
  promises.push new Promise (resolve, reject) ->
    console.log 'find in elastic'
    elastic.like ['_id'], ['information', 'title'], text, 0, 1000000
    .then (ids) ->
      console.log "Elastic found #{ids.length} lots"
      text_lots = ids

      unless _.isEmpty lot_ids
        lot_ids = _.intersection lot_ids, text_lots
      else
        lot_ids = text_lots
      resolve() # query.where _id: $in: ids

Promise.all(promises).then ->
  console.log lot_ids.length
  console.log 'promises resolved'

  query.where _id: $in: lot_ids

  query.skip((page - 1) * perPage).limit(perPage)

  query.populate 'trade'

  # query.where status: 'Приём заявок'
  # query.populate
  #   path: 'tags'
  #   select: 'title color system'
  # query.populate
  #   path: 'aliases'
  #   select: 'title -_id'
  #   model: 'LotAlias'

  console.log 'exec query'
  query.exec (err, lots) ->
    if err
      console.log err
    console.log 'count: ', lots.length

.catch ->
  console.log arguments
