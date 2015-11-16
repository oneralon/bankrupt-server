express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

require '../models/trade'
require '../models/lot'
Trade     = mongoose.model 'Trade'
Lot       = mongoose.model 'Lot'

exports.get = (req, res, next) ->
  id = req.params.id
  unless id?
    return next new Error 'Задайте id'
  Lot.findById(id).populate('trade')
  .populate
    path: 'tags'
    match: $or: [{user: null}, {user: req.user}]
    select: 'title color system'
  .populate
    path: 'aliases'
    match: user: req.user
    select: 'title -_id'
    model: 'LotAlias'
  .exec (err, lot) ->
    if err
      next err
    unless lot?
      return res.status(404).send()

    lot = lot.toObject()
    for interval in lot.intervals
      interval.price_reduction_percent = (1 - interval.interval_price / lot.start_price) * 100
    current_interval = null
    unless _.isEmpty lot.intervals
      current_interval = lot.intervals[0]
      unless new Date() > lot.intervals[lot.intervals.length - 1].interval_end_date
        date = new Date()
        for interval in lot.intervals
          if interval.interval_start_date < date < interval.interval_end_date
            current_interval = interval
            break
      else
        current_interval = lot.intervals[lot.intervals.length - 1]

    lot.current_sum = current_interval?.interval_price or lot.current_sum or lot.start_price

    lot.end_date = lot.trade.results_date or
      lot.trade.holding_date or
      lot.trade.requests_end_date or
      lot.intervals[lot.intervals.length - 1]?.request_end_date

    if req.query.render
      res.render 'full_card',
        lot: lot
    else
      res.status(200).json lot: lot
