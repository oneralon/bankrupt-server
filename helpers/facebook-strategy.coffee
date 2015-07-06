passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
FB        = require 'fb'
_         = require 'lodash'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
fb_config = require "../config/facebook"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'facebook'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    fb_token  = req.fb_token  or req.query.fb_token
    unless device_id? and fb_token?
      return @fail()
    me = @
    @check_fb fb_token, (err, res) ->
      if err?
        return me.fail err
      me.get_fb_info (err, user_info) ->
        console.log user_info
        if err?
          return me.fail err
        User.findOne
          third_party_ids: facebook: user_info.id
        , (err, user) ->
          if err?
            return me.fail err

          if not user?
            error = errors.auth_fail_social
            req.res.status(401).json
              error_code: error?.code
              error_message: error?.message
          return me.success user

  check_fb: (fb_token, cb) ->
    FB.napi 'oauth/access_token',
      grant_type: 'fb_exchange_token'
      client_id: fb_config.app_id
      client_secret: fb_config.app_secret
      fb_exchange_token: fb_token
    , (err, res) ->
      if err?
        return cb err
      FB.setAccessToken res.access_token
      cb null, res


  get_fb_info: (cb) ->
    FB.napi 'me', (err, user_info) ->
      FB.napi 'me/picture',
        redirect: no,
        fields: ['url']
      , (err, res) ->
        if err
          return cb err
        user_info.avatar = res.data.url
        cb null, user_info

module.exports = Strategy
