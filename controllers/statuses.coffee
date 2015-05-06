express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

exports.get = (req, res, next) ->
  console.log req.query
  _v = req.query._v
  mongoose.connection.collection('statuses').findOne { $query: {}, $orderby: { '_v' : -1 } , $limit: 1}, (err, statuses) ->
    if _v < statuses?._v or not _v?
      res.status(200).json statuses
    else
      res.status(304).send()
