express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

require '../models/user'
require '../models/filter_preset'

User          = mongoose.model 'User'
FilterPreset  = mongoose.model 'FilterPreset'

exports.add = (req, res, next) ->
  content   = req.query.content or req.content
  unless content?
    return res.status(500).json err: 'content must be defined'
  preset = new FilterPreset
    user: req.user
    content: content
  preset.save (err, preset) ->
    if err?
      return res.status(500).json err: err
    return res.status(200).json id: preset._id

exports.get = (req, res, next) ->
  preset_id = req.query.preset_id
  unless preset_id?
    return res.status(500).json err: 'preset_id must be defined'
  FilterPreset.findOne
    user: req.user
    _id: preset_id
  , (err, preset) ->
    if err?
      return res.status(500).json err: err
    unless preset?
      return res.status(404).send()
    return res.status(200).json preset: preset

exports.set = (req, res, next) ->
  preset_id = req.query.preset_id or req.preset_id
  content   = req.query.content   or req.content
  unless preset_id?
    return res.status(500).json err: 'preset_id must be defined'
  unless content?
    return res.status(500).json err: 'content must be defined'
  FilterPreset.update
    user: req.user
    _id: preset_id
  ,
    $set: content: content
  , (err, result) ->
    if err?
      return res.status(500).json err: err
    return res.status(200).send()

exports.delete = (req, res, next) ->
  preset_id = req.query.preset_id or req.preset_id
  unless preset_id?
    return res.status(500).json err: 'preset_id must be defined'
  FilterPreset.findOneAndRemove
    user: req.user
    _id: preset_id
  , (err, result) ->
    if err?
      return res.status(500).json err: err
    return res.status(200).send()
