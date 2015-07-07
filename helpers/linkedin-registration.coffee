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
    # super arguments...
    @name = 'linkedin-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    li_token  = req.li_token  or req.query.li_token
    console.log 'li auth'
    unless device_id? and li_token?
      return @fail()
    me = @
    @check_li li_token, (err, li_info) ->
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
          third_party_ids: linkedin: li_info.id
        , (err, li_user) ->
          if err or li_user?
            return me.fail err
          req.user.third_party_ids.addToSet linkedin: li_info.id
          req.user.anonymous = no
          req.user.name = req.user.name or li_info.firstName
          req.user.surname = req.user.surname or li_info.lastName
          req.user.avatar = req.user.avatar or li_info.pictureUrl
          req.user.email = req.user.email or li_info.emailAddress
          req.user.save (err, res) ->
            if err?
              return me.fail err
            return me.success()

  check_li: (access_token, cb) ->
    linkedin = Linkedin.init access_token
    linkedin.people.me (err, me) ->
      if me.errorCode?
        return cb me
      cb null, me

module.exports = Strategy
