mongoose    = require 'mongoose'

require '../models/user'
require '../models/lot'
require '../models/lot_alias'

User        = mongoose.model 'User'
Lot         = mongoose.model 'Lot'

exports.add = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  unless lot_id?
    return res.status(500).json err: err

  req.user.hidden_lots.addToSet lot_id

  req.user.save (err, result) ->
    res.status(500).json err: err if err
    res.status(200).send()

exports.delete = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  unless lot_id?
    return res.status(500).json err: 'lot_id must be defined'

  req.user.hidden_lots.pull lot_id

  req.user.save (err, result) ->
    res.status(500).json err: err if err
    res.status(200).send()
