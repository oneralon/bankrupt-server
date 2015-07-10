passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
_         = require 'lodash'

config    = require '../config/db'
errors    = require './error-codes'

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
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
    User.findOne email: email, (err, mail_user) =>
      if err?
        return @fail err
      if mail_user?
        error = errors.email_exists
        return req.res.status(400).json
          error_code: error?.code
          error_message: error?.message
      User.findOne device: device_id, (err, user) =>
        if err?
          return @fail err
        user = user or new User
          device: device_id
          anonymous: yes
        if user?.anonymous
          user.email    = email
          user.name     = name if name?
          user.surname  = surname if surname?
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
