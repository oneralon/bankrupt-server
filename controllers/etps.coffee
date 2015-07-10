express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

exports.get = (req, res, next) ->
  _v = req.query._v
  mongoose.connection.collection('etps').findOne { $query: {}, $orderby: { '_v' : -1 } , $limit: 1}, (err, etps) ->
    if _v < etps?._v or not _v?
      res.status(200).json etps
    else
      res.status(304).send()
