express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

keymap    = require '../models/tag'

require '../models/tag'
require '../models/lot'
Tag       = mongoose.model 'Tag'
Lot       = mongoose.model 'Lot'

exports.get = (req, res, next) ->
  id    = req.id or req.query.id
  console.log id
  unless _.isEmpty id
    query = Tag.find _id: id
  else
    query = Tag.find()
  query.where $or: [{user: null}, {user: req.user}]
  query.select '_id title color system'
  query.exec (err, tags) ->
    if err?
      return res.status(500).send()
    res.status(200).json tags

exports.add = (req, res, next) ->
  title = req.title or req.query.title
  color = req.color or req.query.color

  if color? and (color[0] isnt '#') and color.length is 6
    color = '#' + color

  if _.isEmpty title
    return res.status(500).json err: 'title must be defined'

  tag   = new Tag
    title: title
    color: color
    user: req.user

  tag.save (err, tag) ->
    if err?
      return res.status(500).send()
    res.status(200).json _id: tag._id

exports.delete = (req, res, next) ->
  id    = req.id or req.query.id

  if _.isEmpty id
    return res.status(500).json err: 'id must be defined'

  query = Tag.findOne _id: id, user: req.user, (err, tag) ->
    if err?
      return res.status(500).json err: err
    if _.isEmpty tag
      return res.status(200).send()
    Lot.update
      tags: tag
    ,
      $pull:
        tags: tag
    ,
      multi: true
    , (err, rowsAffected) ->
      if err?
        return res.status(500).json err: err
      tag.remove (err, status) ->
        if err?
          return res.status(500).json err: err
        res.status(200).json [rowsAffected, status]
