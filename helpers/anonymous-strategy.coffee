passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'

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
    user = User.findOne device: device_id, (err, result) =>
      if result?
        if result.anonymous
          if new Date() < result.license.end_date
            @success result
          else
            @success result
        else
          @fail()
      else
        user = new User
          device: device_id
          license:
            start_date: moment().format()
            end_date: moment().add(days: 14)
        user.save (err, user) =>
          @success user

module.exports = Strategy
