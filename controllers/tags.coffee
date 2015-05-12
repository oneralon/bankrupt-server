express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

keymap    = require '../models/tag'

exports.get = (req, res, next) ->
  res.status(200).json keymap
