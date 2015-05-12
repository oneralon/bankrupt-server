passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'anonymous'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    unless device_id?
      return @fail message: 'Missing device_id'
    user = User.findOne devices: device_id, (err, result) =>
      if result?
        @success result
      else
        user = new User devices: [device_id]
        user.save (err, user) =>
          @success user

module.exports = Strategy
