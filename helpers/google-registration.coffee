passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
_         = require 'lodash'
request   = require 'request'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
gp_config = require "../config/google-plus"

require '../models/user'

User      = mongoose.model 'User'


class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'google-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    gp_token  = req.gp_token  or req.query.gp_token
    email     = req.email  or req.query.email
    console.log 'google auth'
    unless device_id? and gp_token?
      return @fail()
    me = @
    @check_gp gp_token, (err, gp_info) ->
      console.log err
      if err?
        return me.fail err
      User.findOne
        device: device_id
      , (err, user) ->
        if err? or not user?
          return me.fail err

        if user.third_party_ids.length > 0
          error = errors.auth_fail_social_exists
          return req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        User.findOne
          third_party_ids: google: gp_info.id
        , (err, gp_user) ->
          if err or gp_user?
            return me.fail err
          req.user.third_party_ids.addToSet google: gp_info.id
          req.user.anonymous = no
          req.user.name = req.user.name or gp_info.name.givenName
          req.user.surname = req.user.surname or gp_info.name.familyName
          req.user.avatar = req.user.avatar or gp_info.image.url
          req.user.email = req.user.email or email
          req.user.save (err, res) ->
            if err?
              return me.fail err
            return me.success()

  check_gp: (access_token, cb) ->
    request.get gp_config.url + access_token, (err, res, body) ->
      body = JSON.parse body
      if body.error?.code
        return cb body.error
      cb null, body

module.exports = Strategy
