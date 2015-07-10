mongoose      = require 'mongoose'
passport      = require 'passport-strategy'


require '../models/user'

User          = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    @name = 'activation'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    hash = req.query.hash
    unless hash?
      return @fail message: 'Missing hash'
    User.findOne activation_hash: hash, (err, user) =>
      if err?
        return @error err
      unless user?
        return @fail()
      user.activation_hash = undefined
      user.activated = yes
      user.save (err, user) =>
        if err?
          return @error err
        if user?
          return @success user
        else
          return @fail()

module.exports = Strategy
