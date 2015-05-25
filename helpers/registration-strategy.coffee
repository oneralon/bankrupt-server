passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'

config    = require "../config/db"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    email     = req.email     or req.query.email
    pass      = req.pass      or req.query.pass
    name      = req.name      or req.query.name
    surname   = req.surname   or req.query.surname
    unless device_id? and email? and pass?
      return @fail()
    User.findOne device: device_id, (err, user) =>
      if err?
        return @fail err
      if user?.anonymous
        user.email    = email
        user.name     = name
        user.surname  = surname
        user.password = bcrypt.hashSync pass, 10
        user.anonymous = no
        user.save (err, user) =>
          if err?
            return @fail err
          if user?
            @success user
          else
            @fail()
      else
        return @fail()

module.exports = Strategy
