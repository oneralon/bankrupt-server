passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
Twitter   = require 'twitter'
_         = require 'lodash'

config    = require "../config/db"
tw_config = require "../config/twitter"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'twitter-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    tw_token  = req.tw_token  or req.query.tw_token
    tw_secret = req.tw_secret or req.query.tw_secret
    unless device_id? and tw_token?
      return @fail()
    me = @
    @check_tw tw_token, tw_secret, (err, user_info) ->
      if err?
        return me.fail err
      User.findOne
        device: device_id
      , (err, user) ->
        if err? or not user?
          return me.fail err
        User.findOne
          third_party_ids: twitter: user_info.id
        , (err, tw_user) ->
          if err or tw_user?
            return me.fail err
          req.user.third_party_ids.addToSet twitter: user_info.id
          req.user.anonymous = no
          req.user.name = req.user.name or user_info.name.split(' ')?[0]
          req.user.surname = req.user.surname or user_info.name.split(' ')?[1]
          req.user.avatar = req.user.avatar or user_info.profile_image_url
          req.user.email = req.user.email or user_info.email
          req.user.save (err, res) ->
            if err?
              return me.fail err
            return me.success()

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
