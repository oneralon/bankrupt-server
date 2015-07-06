passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
VK        = require 'vksdk'
_         = require 'lodash'

config    = require "../config/db"
errors    = require '../helpers/error-codes'
vk_config = require "../config/vk"

require '../models/user'

User      = mongoose.model 'User'
vk        = new VK
  appId: vk_config.app_id
  appSecret: vk_config.app_secret
  language: 'ru'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    # super arguments...
    @name = 'vk'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    vk_token  = req.vk_token  or req.query.vk_token
    unless device_id? and vk_token?
      return @fail()
    me = @
    @check_vk vk_token, (err, res) ->
      if err?
        return me.fail err
      # me.get_vk_info res.user_id, (err, user_info) ->
      #   console.log user_info
      #   if err?
      #     return me.fail err
      User.findOne
        third_party_ids: vk: res.user_id
      , (err, user) ->
        if err?
          return me.fail err
        if not user?
          error = errors.auth_fail_social
          req.res.status(401).json
            error_code: error?.code
            error_message: error?.message
        return me.success user

  check_vk: (token, cb) ->
    # userToken = token
    # vk.setToken token
    vk.setSecureRequests true
    vk.requestServerToken (res) ->
      vk.setToken res.access_token
      vk.request 'secure.checkToken', token: token
      , (res) ->
        if res.error?
          return cb res.error
        # vk.setToken userToken
        vk.setToken undefined
        return cb null, res.response

  get_vk_info: (user_id, cb) ->
    fields = 'sex,city,country,photo_50'
    vk.request 'users.get', {user_id: user_id, fields: fields}, (result) ->
      if result.error?
        return cb result.error
      cb null, result.response?[0]

module.exports = Strategy
