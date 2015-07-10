express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

exports.get = (req, res, next) ->
  _v = req.query._v
  mongoose.connection.collection('regions').findOne { $query: {}, $orderby: { '_v' : -1 } , $limit: 1}, (err, regions) ->
    if _v < regions?._v or not _v?
      res.status(200).json regions
    else
      res.status(304).send()
