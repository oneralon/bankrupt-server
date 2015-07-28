mongoose  = require 'mongoose'

require '../models/promocode'
require '../models/license'
require '../models/user'

Promocode = mongoose.model 'Promocode'
License   = mongoose.model 'License'
User      = mongoose.model 'User'

exports.enter = (req, res) ->
  code = req.body.code
  Promocode.findOne {code: code}, (err, promocode) =>
    res.status(500).send() if err?
    if promocode?
      expired = if promocode.expiration
        if promocode.expiration - new Date() < 0 then true else false
      else false
      res.status(400).json {error: 'Expired'} if expired
      if promocode.count is 0
        res.status(400).json {error: 'Spent'}
      else
        req.user.promocodes = [] unless req.user.promocodes
        activated = false
        for promo in req.user.promocodes
          if code is promo.code
            activated = true
            break
        unless activated
          req.user.promocodes.push promocode
        req.user.save (err, result) =>
          res.status(500).json err: err if err
          if promocode.count
            promocode.count = promocode.count - 1
            promocode.save (err, result) =>
              res.status(500).json err: err if err
              res.status(200).send()
          else res.status(200).send()
    else res.status(404).send()

exports.generate = (req, res) ->
  try
    percent     = parseInt req.body.percent
    title       = req.body.title.trim()
    count       = parseInt req.body.count
    activations = parseInt req.body.activations
    expiration  = if req.body.expiration isnt ''
      new Date req.body.expiration
    else null
    License.findOne
      '_id': mongoose.Types.ObjectId req.body.license
    , (err, license) =>
      unless license
        res.render 'error',
          message: 'Error in fields'
          error: err
      Promocode.generate count,
        code: null
        percent: percent
        title: title
        count: activations
        expiration: expiration
        license_name: license.name
        license: license._id
      , (err, codes) =>
        str = ''
        for code in codes
          str += "\n#{code}"
        res.render 'generate_promocode',
          percent: percent
          title: title
          count: count
          activations: activations
          expiration: expiration
          license: license.title
          codes: str
  catch e
    res.render 'error',
      message: 'Error in fields'
      error: e

exports.create = (req, res) ->
  License.find (err, licenses) =>
    render 'error', {error: err, message: 'Error in licenses findAll'} if err?
    res.render 'create_promocode',
      licenses: licenses