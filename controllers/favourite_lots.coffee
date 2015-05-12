mongoose    = require 'mongoose'

require '../models/user'
require '../models/lot'

User        = mongoose.model 'User'
Lot         = mongoose.model 'Lot'

exports.add = (req, res) ->
  lot_id = req.query.lot_id or req.lot_id
  unless lot_id?
    return res.status(500).send()

  req.user.favourite_lots.addToSet lot_id

  req.user.save (err, result) ->
    res.status(500).send() if err
    res.status(200).send()

exports.check = (req, res) ->
  last_check = req.query.last_check or req.last_check
  unless last_check?
    last_check = new Date(0)
  console.log req.user.favourite_lots
  Lot.find({_id: {$in: req.user.favourite_lots}, last_message: $gt: last_check}, {_id: 1}).exec (err, result) ->
    res.status(200).json result
