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
  .populate('tags')
  .populate 'tags', 'title color'
  .populate
    path: 'aliases'
    match: user: req.user
    select: 'title -_id'
    model: 'LotAlias'
  .exec (err, lot) ->
    if err
      console.log err
      next err
    unless lot?
      return res.status(404).send()

    lot = lot.toObject()
    lot.end_date = lot.trade.results_date or
      lot.trade.holding_date or
      lot.trade.requests_end_date or
      lot.intervals[lot.intervals.length - 1]?.request_end_date

    if req.query.render
      res.render 'full_card',
        lot: lot
    else
      res.status(200).json lot: lot
