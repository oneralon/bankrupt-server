passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
crypto    = require 'crypto'
request   = require 'request'
_         = require 'lodash'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
ok_config = require "../config/odnoklassniki"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'odnoklassniki'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    ok_token  = req.ok_token  or req.query.ok_token
    unless device_id? and ok_token?
      return @fail()
    console.log 'ok strategy'
    me = @
    @check_ok ok_config.app_public, ok_config.app_secret, ok_token, (err, user_info) ->
      if err?
        error = errors.auth_fail_social
        return req.res.status(401).json
          error_code: error?.code
          error_message: error?.message
          original_error: err
      User.findOne
        third_party_ids: odnoklassniki: user_info.uid
      , (err, user) ->
        if err?
          return me.fail err

        if not user?
          error = errors.auth_fail_social
          return req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        return me.success user

  check_ok: (client_public, client_secret, accessToken, cb) ->
    sig = crypto.createHash('md5').update([
      'application_key=' + client_public
      'method=users.getCurrentUser'
      crypto.createHash('md5').update(accessToken + client_secret, 'utf8').digest('hex').toLowerCase()
    ].join(''), 'utf8').digest('hex').toLowerCase()

    url = 'http://api.odnoklassniki.ru/fb.do?application_key=' + client_public + '&method=users.getCurrentUser&access_token=' + accessToken + '&sig=' + sig

    request.get url, (err, res, body) ->
      body = JSON.parse body
      if body.error_code
        err = body
        body = null
      cb err, body


module.exports = Strategy
