mongoose  = require 'mongoose'

require '../models/promocode'
require '../models/license'
require '../models/user'

Promocode = mongoose.model 'Promocode'
License   = mongoose.model 'License'
User      = mongoose.model 'User'



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
        activations: activations
        expiration: expiration
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