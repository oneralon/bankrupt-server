passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
Linkedin  = require 'node-linkedin'
_         = require 'lodash'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
li_config = require "../config/linkedin"

require '../models/user'

User      = mongoose.model 'User'


Linkedin  = Linkedin li_config.cliend_id, li_config.client_secret

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    @name = 'linkedin'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    li_token  = req.li_token  or req.query.li_token
    unless device_id? and li_token?
      return @fail()
    me = @
    @check_li li_token, (err, user_info) ->
      if err?
        return me.fail err
      User.findOne
        third_party_ids: linkedin: user_info.id
      , (err, user) ->
        if err?
          return me.fail err

        if not user?
          error = errors.auth_fail_social
          return req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        return me.success user

  check_li: (access_token, cb) ->
    linkedin = Linkedin.init access_token
    linkedin.people.me (err, me) ->
      if me.errorCode?
        return cb me
      cb null, me

module.exports = Strategy
