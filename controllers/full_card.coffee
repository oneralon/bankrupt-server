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
  Lot.findById(id).populate('trade').exec (err, lot) ->
    if err
      console.log err
      next err
    unless lot?
      lot = {}

    if req.query.render
      res.render 'full_card',
        lot: lot
    else
      res.status(200).json lot: lot
