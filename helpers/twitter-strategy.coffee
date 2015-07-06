passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
Twitter   = require 'twitter'
_         = require 'lodash'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
tw_config = require "../config/twitter"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'twitter'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    tw_token  = req.tw_token  or req.query.tw_token
    tw_secret = req.tw_secret or req.query.tw_secret
    unless device_id? and tw_token? and tw_secret?
      return @fail()
    me = @
    @check_tw tw_token, tw_secret, (err, user_info) ->
      if err?
        return me.fail err
      User.findOne
        third_party_ids: twitter: user_info.id
      , (err, user) ->
        if err?
          return me.fail err

        if not user?
          error = errors.auth_fail_social
          req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        return me.success user

  check_tw: (token, secret, cb) ->
    client = new Twitter
      consumer_key: tw_config.consumer_key
      consumer_secret: tw_config.consumer_secret
      access_token_key: token
      access_token_secret: secret

    client.get "account/verify_credentials", (error, details) ->
      unless _.isEmpty error
        return cb error
      cb null, details

module.exports = Strategy
