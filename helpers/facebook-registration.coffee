passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
FB        = require 'fb'
_         = require 'lodash'

config    = require "../config/db"
fb_config = require "../config/facebook"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'facebook-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    fb_token  = req.fb_token  or req.query.fb_token
    unless device_id? and fb_token?
      return @fail()
    console.log 'get fb long token'
    me = @
    @check_fb fb_token, (err, res) ->
      if err?
        return me.fail err
      console.log 'get fb user info'
      me.get_fb_info (err, user_info) ->
        console.log user_info
        if err?
          return me.fail err
        User.findOne
          device: device_id
        , (err, user) ->
          if err? or not user?
            console.log 'fail because err', err, user
            return me.fail err


          if user.third_party_ids.length > 0
            error = errors.auth_fail_social_exists
            return req.res.status(401).json
              error_code: error?.code
              error_message: error?.message
          User.findOne
            third_party_ids: facebook: user_info.id
          , (err, fb_user) ->
            if err or fb_user?
              return me.fail err
            user.third_party_ids.addToSet facebook: user_info.id
            user.anonymous = no
            user.name = user_info.first_name
            user.surname = user_info.last_name
            user.avatar = user_info.avatar
            user.email = user_info.email
            user.save (err, res) ->
              if err?
                return me.fail err
              return me.success()

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
