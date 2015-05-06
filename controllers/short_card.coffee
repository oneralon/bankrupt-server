express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

require '../models/trade'
require '../models/lot'
Trade     = mongoose.model 'Trade'
Lot       = mongoose.model 'Lot'

exports.list = (req, res, next) ->
  page = Number(req.query.page) or 1
  perPage = Number(req.query.perPage) or 30
  tag = req.query.tag or ''
  Lot.find(unless _.isEmpty(tag) then tags: $in: [tag]).skip((page-1)*perPage).sort(last_message: -1).limit(perPage).populate('trade').exec (err, lots) ->
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
        duration = moment.duration(moment(nextInterval.interval_start_date).diff new Date()) if nextInterval?
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
        next_interval_start_date: duration.humanize() if duration?
        end_date: moment.duration(moment(item.trade.requests_end_date or
          item.intervals[item.intervals.length - 1]?.request_end_date or
          item.trade.holding_date or
          item.trade.results_date).diff(new Date())
        ).humanize()
        tags: item.tags
      }

    if req.query.render
      res.render 'short_card',
        lots: lots
        currentTag: tag
        pages: [(parseInt(page/10)*10 + if page < 10 then 1 else 0)..parseInt(page/10)*10+9]
        currentPage: page
    else
      res.status(200).json lots: lots
