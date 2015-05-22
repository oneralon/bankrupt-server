passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
Linkedin  = require 'node-linkedin'
_         = require 'lodash'

config    = require "../config/db"
li_config = require "../config/linkedin"

require '../models/user'

User      = mongoose.model 'User'


Linkedin  = Linkedin li_config.cliend_id, li_config.client_secret

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
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
        if err? or not user?
          return me.fail err
        return me.success user

  check_li: (access_token, cb) ->
    linkedin = Linkedin.init access_token
    linkedin.people.me (err, me) ->
      if me.errorCode?
        return cb me
      cb null, me

module.exports = Strategy
