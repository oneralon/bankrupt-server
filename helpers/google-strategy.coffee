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
    @name = 'google'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    gp_token  = req.gp_token  or req.query.gp_token
    email     = req.email  or req.query.email
    unless device_id? and gp_token?
      return @fail()
    me = @
    @check_gp gp_token, (err, gp_info) ->
      if err?
        return me.fail err
      User.findOne
        third_party_ids: google: gp_info.id
      , (err, user) ->
        if err?
          return me.fail err

        if not user?
          error = errors.auth_fail_social
          return req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        return me.success user

  check_gp: (access_token, cb) ->
    request.get gp_config.url + access_token, (err, res, body) ->
      body = JSON.parse body
      console.log body
      if body.error?.code
        return cb body.error
      cb null, body

module.exports = Strategy
