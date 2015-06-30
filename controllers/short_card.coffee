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

exports.list = (req, res, next) ->
  page = Number(req.query.page) or 1
  perPage = Number(req.query.perPage) or 30
  tags = req.query.tags or []
  statuses = req.query.statuses
  etps = req.query.etps
  regions = req.query.regions
  start_price = req.query.startPrice
  end_price = req.query.endPrice
  text = req.query.text
  my_lots_only = req.query.my_lots or req.my_lots
  trade_types = req.query.tradeTypes?.map (item) -> item.toLowerCase()
  membership_types = req.query.membershipTypes?.map (item) -> item.toLowerCase()
  price_submission_types = req.query.priceSubmissionTypes?.map (item) -> item.toLowerCase()
  sort = req.query.sort or 'last_message'
  sort_order = req.query.sortOrder or 'desc'

  promises  = []
  lot_ids   = []

  query = Lot.find()

  query.where _id: $nin: req.user.hidden_lots

  unless _.isEmpty tags
    query.where tags: $in: tags

  unless _.isEmpty statuses
    query.where status: $in: statuses

  unless _.isEmpty start_price
    query.where start_price: $gte: start_price

  unless _.isEmpty end_price
    query.where start_price: $lte: end_price

  unless _.isEmpty regions
    regions.push 'Не определен'
    query.where region: $in: regions

  unless _.isEmpty(etps) and _.isEmpty(regions) and _.isEmpty(trade_types) and _.isEmpty(membership_types) and _.isEmpty(price_submission_types)
    promises.push new Promise (resolve, reject) ->
      tradeQuery = {}
      unless _.isEmpty etps
        tradeQuery['etp.name'] = $in: etps
      # unless _.isEmpty regions
      #   tradeQuery.region = $in: regions
      unless _.isEmpty trade_types
        tradeQuery['trade_type'] = $in: trade_types
      unless _.isEmpty membership_types
        tradeQuery['membership_type'] = $in: membership_types
      unless _.isEmpty price_submission_types
        tradeQuery['price_submission_type'] = $in: price_submission_types

      mongoose.connection.collection('trades').find tradeQuery, {'lots': 1}, (err, cursor) ->
        cursor.toArray (err, trades) ->
          lots = []
          for trade in trades
            lots = lots.concat trade.lots
          public_lots = lots.map (item) -> return item.toString()

          console.log 'Mongo has ', public_lots.length

          unless _.isEmpty lot_ids
            lot_ids = _.intersection lot_ids, public_lots
          else
            lot_ids = public_lots
          resolve public_lots

  unless _.isEmpty text
    promises.push new Promise (resolve, reject) ->
      elastic.like ['_id'], ['information', 'title^2'], text, 0, 1000000
      .then (ids) ->
        text_lots = ids

        console.log 'Elastic has ', text_lots.length

        unless _.isEmpty lot_ids
          lot_ids = _.intersection lot_ids, text_lots
        else
          lot_ids = text_lots
        resolve text_lots # query.where _id: $in: ids

  if my_lots_only
    unless _.isEmpty lot_ids
      lot_ids = _.intersection lot_ids, req.user.favourite_lots.map (item) -> item.toString()
    else
      lot_ids = req.user.favourite_lots.map (item) -> item.toString()

  Promise.all(promises).then ->

    console.log 'All promises resolved'

    unless _.isEmpty lot_ids
      query.where _id: $in: lot_ids

    query.sort("#{sort}": "#{sort_order}")

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
      console.log 'query executed'

      if err
        console.log err
        res.status(500)
        return next err
      if not lots? or lots.length is 0
        lots = []

      lots = lots.map (item) ->
        current_interval = null
        unless _.isEmpty item.intervals
          current_interval = item.intervals[0]
          unless new Date() > item.intervals[item.intervals.length - 1].interval_end_date
            date = new Date()
            for interval in item.intervals
              if interval.interval_start_date < date < interval.interval_end_date
                current_interval = interval
                break

            nextInterval = item.intervals[item.intervals.indexOf(current_interval) + 1] or undefined

          else
            nextInterval = item.intervals[item.intervals.length - 1]

          if nextInterval?
            duration = moment(nextInterval.interval_start_date)

        # unless _.isEmpty item.intervals
        #   current_interval = item.intervals[0]
        #   date = new Date()
        #   for interval in item.intervals
        #     if interval.interval_start_date < date < interval.interval_end_date
        #       current_interval = interval
        #       break
        #   nextInterval = item.intervals[item.intervals.indexOf(current_interval) + 1] or undefined
        #   if nextInterval?
        #     duration = moment(nextInterval.interval_start_date)

        end_date = moment(item.trade.results_date or
          item.trade.holding_date or
          item.trade.requests_end_date or
          item.intervals[item.intervals.length - 1]?.request_end_date)

        if req.query.render
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
          next_interval_start_date: duration
          end_date: end_date
          tags: item.tags
          aliases: item.aliases or undefined
        }

      if req.query.render
        res.render 'short_card',
          lots: lots
          currentTag: tags
          pages: [(parseInt(page/10)*10 + if page < 10 then 1 else 0)..parseInt(page/10)*10+9]
          currentPage: page
      else
        res.status(200).json lots: lots
  .catch (err) ->
    console.log err
