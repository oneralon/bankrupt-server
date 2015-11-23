express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'
Promise   = require 'promise'

elastic   = require '../helpers/elastic'

require '../models/trade'
require '../models/lot'
require '../models/lot_alias'
Trade     = mongoose.model 'Trade'
Lot       = mongoose.model 'Lot'
LotAlias  = mongoose.model 'LotAlias'

error = (err) ->
  console.error err
  res.status(500).json err

normalize = (field, def) ->
  return [] if _.isEqual(field, [''])
  unless field?
    def or []
  else field

exports.list = (req, res, next) ->
  page = Number(req.query.page) or 1
  perPage = Number(req.query.perPage) or 30
  if perPage > 100 then perPage = 30
  tags = normalize req.query.tags
  statuses = normalize req.query.statuses
  etps = normalize req.query.etps
  regions = normalize req.query.regions
  start_price = req.query.startPrice
  end_price = req.query.endPrice
  text = req.query.text
  my_lots_only = req.query.my_lots or req.my_lots
  trade_types = req.query.tradeTypes?.map (item) -> item.toLowerCase()
  membership_types = req.query.membershipTypes?.map (item) -> item.toLowerCase()
  price_submission_types = req.query.priceSubmissionTypes?.map (item) -> item.toLowerCase()
  sort = req.query.sort or 'last_message'
  sort_order = req.query.sortOrder or 'desc'

  lot_ids = null

  if my_lots_only
    if _.isEmpty req.user.favourite_lots then return res.status(200).json lots: []
    else lot_ids = req.user.favourite_lots.map (item) -> item.toString()
  tradesFound = new Promise (resolve, reject) ->
    unless _.isEmpty(etps) and _.isEmpty(regions) and _.isEmpty(trade_types) and _.isEmpty(membership_types) and _.isEmpty(price_submission_types)
      query = {}
      unless _.isEmpty etps
        query['etp.name'] = $in: etps.map (i) -> new RegExp '^' + i + '$', 'i'
      unless _.isEmpty trade_types
        query['trade_type'] = $in: trade_types.map (i) -> new RegExp '^' + i + '$', 'i'
      unless _.isEmpty membership_types
        query['membership_type'] = $in: membership_types.map (i) -> new RegExp '^' + i + '$', 'i'
      unless _.isEmpty price_submission_types
        query['price_submission_type'] = $in: price_submission_types.map (i) -> new RegExp '^' + i + '$', 'i'
      if _.isEmpty query then resolve(null)
      else
        Trade.find(query).select('_id').exec (err, trades) ->
          reject err if err?
          resolve trades
    else resolve(null)

  elasticFound = new Promise (resolve, reject) ->
    tradesFound.catch(error).then (trades) ->
      unless text?
        resolve({trades: trades, lot_ids: lot_ids})
      else
        trade_ids = unless trades? then null else trades.map (i) -> i._id.toString()
        elastic.like ['_id'], text, 0, 10000, lot_ids, trade_ids, regions, statuses, etps
        .then (ids) ->
          resolve({trades: trades, lot_ids: ids})

  lotsFound = new Promise (resolve, reject) ->
    elasticFound.catch(error).then (params) ->
      if _.isEqual(params.lot_ids, []) or _.isEqual(params.trades, [])
        return res.status(200).json lots: [] 
      query = Lot.find()
      count = Lot.count()
      if /^дом$/i.test text
        query.where title: /дом(?!(\s*(№|\d)))/i
        count.where title: /дом(?!(\s*(№|\d)))/i
      query.where title: {$exists: true}
      count.where title: {$exists: true}
      query.where last_event: $ne: null
      count.where last_event: $ne: null
      unless params.lot_ids is null
        query.where('_id').in params.lot_ids
        count.where('_id').in params.lot_ids
      query.where _id: $nin: req.user.hidden_lots
      count.where _id: $nin: req.user.hidden_lots
      if params.trades?
        query.where trade: $in: params.trades
        count.where trade: $in: params.trades
      unless _.isEmpty tags
        query.where tags: $in: tags
        count.where tags: $in: tags
      unless _.isEmpty statuses
        query.where status: $in: statuses.map (i) -> new RegExp i, 'i'
        count.where status: $in: statuses.map (i) -> new RegExp i, 'i'
      unless _.isEmpty start_price
        query.where current_sum: $gte: start_price
        count.where current_sum: $gte: start_price
      unless _.isEmpty end_price
        query.where current_sum: $lte: end_price
        count.where current_sum: $lte: end_price
      unless _.isEmpty regions
        query.where('region').in regions.map (i) -> new RegExp i, 'i'
        count.where('region').in regions.map (i) -> new RegExp i, 'i'
      query.where present: $exists: true
      query.sort(present: -1, "#{sort}": "#{sort_order}")
      query.skip((page - 1) * perPage).limit(perPage)
      query.populate 'trade'
      query.populate
        path: 'tags'
        match: $or: [{user: null}, {user: req.user}]
        select: 'title color system'
      query.populate
        path: 'aliases'
        match: user: req.user
        select: 'title -_id'
        model: 'LotAlias'
      query.exec (err, lots) ->
        reject(err) if err?
        count.exec (err, count) ->
          reject(err) if err?
          console.log '======================================', count
          if not lots? or lots.length is 0 then resolve(lots: [], count: count)
          resolve({lots: lots, count: count})

  lotsFound.catch(error).then (result) ->
    lots = result.lots
    lots = lots.map (item) ->
      current_interval = null
      intervals = item.intervals.filter (i) -> i.interval_end_date > new Date()
      unless _.isEmpty intervals
        current_interval = intervals[0]
        nextInterval = intervals[intervals.indexOf(current_interval) + 1] or intervals[intervals.length - 1]
      if nextInterval?
        duration = moment(nextInterval.interval_start_date)
      end_date = moment(item.last_event)
      if req.query.render is 'true'
        duration = moment.duration(duration.diff new Date()).humanize() if duration?
        end_date = moment.duration(end_date.diff new Date()).humanize() if end_date?
      return {
        id: item.id
        url: item.url
        trade: item.trade.title?.substr 0, 100
        trade_url: item.trade.url
        title: item.title.substr 0, 100
        type: item.trade.type
        status: item.status
        region: item.region
        start_price: item.start_price
        current_price: current_interval?.interval_price or item.current_sum or item.start_price
        discount: item.discount
        end_date: duration or end_date
        tags: item.tags
        aliases: item.aliases or undefined
      }
    if req.query.render is 'true'
      mongoose.connection.collection('etps').find {}, {sort: {_v: -1}, limit: 1}, (err, cursor) ->
        cursor.toArray (err, etp) ->
          error err if err?
          mongoose.connection.collection('statuses').find {}, {sort: {_v: -1}, limit: 1}, (err, cursor) ->
            cursor.toArray (err, status) ->
              error err if err?
              mongoose.connection.collection('regions').find {}, {sort: {_v: -1}, limit: 1}, (err, cursor) ->
                cursor.toArray (err, region) ->
                  error err if err?
                  res.render 'short_card',
                    etps: etp[0].list
                    statuses: status[0].list
                    regions: region[0].list
                    lots: lots
                    currentTag: tags
                    pages: [(parseInt(page/10)*10 + if page < 10 then 1 else 0)..parseInt(page/10)*10+9]
                    currentPage: page
    else
      res.status(200).json {lots: lots, count: result.count}
