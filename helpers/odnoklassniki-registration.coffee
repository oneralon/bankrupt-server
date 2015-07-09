passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
_         = require 'lodash'
crypto    = require 'crypto'
request   = require 'request'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
ok_config = require "../config/odnoklassniki"

require '../models/user'

User      = mongoose.model 'User'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'odnoklassniki-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    ok_token  = req.ok_token  or req.query.ok_token
    console.log 'ok auth'
    unless device_id? and ok_token?
      return @fail()
    me = @
    @check_ok ok_config.app_public, ok_config.app_secret, ok_token, (err, ok_info) ->
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
          third_party_ids: odnoklassniki: ok_info.id
        , (err, ok_user) ->
          if err or ok_user?
            return me.fail err
          req.user.third_party_ids.addToSet odnoklassniki: ok_info.uid
          req.user.anonymous = no
          req.user.name = req.user.name or ok_info.first_name
          req.user.surname = req.user.surname or ok_info.last_name
          req.user.avatar = req.user.avatar or ok_info.pic_1
          req.user.save (err, res) ->
            if err?
              return me.fail err
            return me.success req.user

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
