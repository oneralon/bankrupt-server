passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'

config    = require "../config/db"
errors    = require './error-codes'

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    @name = 'registered'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    email     = req.email     or req.query.email
    pass      = req.pass      or req.query.pass
    unless device_id? and email? and pass?
      return @fail()
    email = new RegExp(email, 'i')
    User.findOne
      email: {$regex: email}
    , (err, user) =>
      if err?
        return @fail err
      if user? and not user.anonymous
        if bcrypt.compareSync pass, user.password
          @success user
        else
          error = errors.auth_fail_credentials
          req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
          @fail()
      else
        error = errors.auth_fail_credentials
        req.res.status(401).json
          error_code: error?.code
          error_message: error?.message
        return @fail()

module.exports = Strategy
