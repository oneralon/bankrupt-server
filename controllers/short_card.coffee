express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'
Promise   = require 'promise'

require '../models/trade'
require '../models/lot'
Trade     = mongoose.model 'Trade'
Lot       = mongoose.model 'Lot'

exports.list = (req, res, next) ->
  page = Number(req.query.page) or 1
  perPage = Number(req.query.perPage) or 30
  tags = req.query.tags or ''
  statuses = req.query.statuses
  etps = req.query.etps
  regions = req.query.regions
  start_price = req.query.startPrice
  end_price = req.query.endPrice
  text = req.query.text

  promises = []

  query = Lot.find()

  unless _.isEmpty tags
    query.where tags: $in: [tags]

  unless _.isEmpty statuses
    query.where status: $in: statuses

  unless _.isEmpty start_price
    query.where start_price: $gte: start_price

  unless _.isEmpty end_price
    query.where end_price: $gte: end_price

  unless _.isEmpty(etps) and _.isEmpty(regions)
    promises.push new Promise (resolve, reject) ->
      tradeQuery = {}
      unless _.isEmpty etps
        tradeQuery['etp.name'] = $in: etps
      unless _.isEmpty regions
        tradeQuery.region = $in: regions

      console.log tradeQuery
      mongoose.connection.collection('trades').find tradeQuery, {'_id': 1}, (err, cursor) ->
        cursor.toArray (err, ids) ->
          query.where trade: $in: ids
          resolve()

  unless _.isEmpty text
    query.where $text: $search: text

  Promise.all(promises).then ->
    query.sort(last_message: -1).limit(perPage)

    query.populate 'trade'

    query.exec (err, lots) ->
      if err
        console.log err
        res.status(500)
        return next err
      if not lots? or lots.length is 0
        lots = []

      lots = lots.map (item) ->
        unless _.isEmpty item.intervals
          current_interval = item.intervals[0]
          date = new Date()
          for interval in item.intervals
            if interval.interval_start_date < date < interval.interval_end_date
              current_interval = interval
              break
          nextInterval = item.intervals[item.intervals.indexOf(current_interval) + 1] or undefined
          if nextInterval?
            duration = moment(nextInterval.interval_start_date)

        end_date = moment(item.trade.requests_end_date or
          item.intervals[item.intervals.length - 1]?.request_end_date or
          item.trade.holding_date or
          item.trade.results_date)

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
          region: item.trade.region
          start_price: item.start_price
          current_price: current_interval?.interval_price or item.current_sum or item.start_price
          next_interval_start_date: duration
          end_date: end_date
          tags: item.tags
        }

      if req.query.render
        res.render 'short_card',
          lots: lots
          currentTag: tags
          pages: [(parseInt(page/10)*10 + if page < 10 then 1 else 0)..parseInt(page/10)*10+9]
          currentPage: page
      else
        res.status(200).json lots: lots
