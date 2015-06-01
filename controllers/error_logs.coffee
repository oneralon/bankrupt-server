express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

require '../models/user'
require '../models/error_log'

User        = mongoose.model 'User'
ErrorLog    = mongoose.model 'ErrorLog'

exports.add = (req, res, next) ->
  content   = req.query.content or req.content
  unless content?
    return res.status(500).json err: 'content must be defined'
  error_log = new ErrorLog
    user: req.user or undefined
    content: content
    date: new Date()
  error_log.save (err, error_log) ->
    if err?
      return res.status(500).json err: err
    return res.status(200).json id: error_log._id
