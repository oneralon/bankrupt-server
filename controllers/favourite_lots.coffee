mongoose    = require 'mongoose'

require '../models/user'
require '../models/lot'
require '../models/lot_alias'

User        = mongoose.model 'User'
Lot         = mongoose.model 'Lot'
LotAlias    = mongoose.model 'LotAlias'

exports.add = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  unless lot_id?
    return res.status(500).json err: err

  req.user.favourite_lots.addToSet lot_id

  req.user.save (err, result) ->
    res.status(500).json err: err if err
    res.status(200).send()

exports.delete = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  unless lot_id?
    return res.status(500).json err: 'lot_id must be defined'

  req.user.favourite_lots.pull lot_id

  req.user.save (err, result) ->
    res.status(500).json err: err if err
    res.status(200).send()

exports.setAlias = (req, res) ->
  lot_id      = req.query.lot_id  or req.lot_id
  alias_title = req.query.alias   or req.alias
  user        = req.user
  unless lot_id?
    return res.status(500).json err: 'lot_id must be defined'
  unless alias_title?
    return res.status(500).json err: 'alias must be defined'

  LotAlias.findOne
    user: user
    lot: lot_id
  , (err, alias) ->
    if err?
      res.status(500).json err: err
    if alias?
      alias.title = alias_title
      alias.save (err, alias) ->
        if err?
          return res.status(500).json err: err
        res.status(200).send()
    else
      Lot.findById lot_id, (err, lot) ->
        if err?
          return res.status(500).json err: err
        unless lot?
          return res.status(404).send()
        alias = new LotAlias
          user: user
          lot: lot
          title: alias_title
        alias.save (err, alias) ->
          if err?
            return res.status(500).json err: err
          lot.aliases.addToSet alias
          lot.save (err, lot) ->
            if err?
              return res.status(500).json err: err
            res.status(200).send()

exports.addTag = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  tag_id = req.query.tag_id or req.tag_id
  unless lot_id?
    return res.status(500).json err: 'lot_id must be defined'
  unless tag_id?
    return res.status(500).json err: 'tag_id must be defined'

  Lot.findById lot_id, (err, lot) ->
    if err?
      return res.status(500).json err: err
    unless lot?
      return res.status(404).send()
    lot.tags.addToSet tag_id
    lot.save (err, lot) ->
      if err?
        return res.status(500).json err: err
      res.status(200).send()


exports.removeTag = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  tag_id = req.query.tag_id or req.tag_id
  unless lot_id?
    return res.status(500).json err: 'lot_id must be defined'
  unless tag_id?
    return res.status(500).json err: 'tag_id must be defined'

  Lot.findById lot_id, (err, lot) ->
    if err?
      return res.status(500).json err: err
    unless lot?
      return res.status(404).send()
    lot.tags.pull tag_id
    lot.save (err, lot) ->
      if err?
        return res.status(500).json err: err
      res.status(200).send()



exports.check = (req, res) ->
  last_check = req.query.last_check or req.last_check
  unless last_check?
    last_check = new Date(0)
  console.log req.user.favourite_lots
  Lot.find({_id: {$in: req.user.favourite_lots}, last_message: $gt: last_check}, {_id: 1}).exec (err, result) ->
    res.status(200).json result
