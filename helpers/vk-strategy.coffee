passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
bcrypt    = require 'bcrypt'
VK        = require 'vksdk'
_         = require 'lodash'

config    = require "../config/db"
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
      me.get_vk_info (err, user_info) ->
        console.log user_info
        if err?
          return me.fail err
        User.findOne
          third_party_ids: vk: user_info.id
        , (err, user) ->
          if err? or not user?
            return me.fail err
          return me.success user

  check_vk: (token, cb) ->
    userToken = token
    vk.setToken token
    vk.setSecureRequests true
    vk.requestServerToken (res) ->
      console.log 'serverTokenReady', res
      vk.setToken res.access_token
      vk.request 'secure.checkToken', token: token
      , (res) ->
        if res.error?
          return cb res.error
        vk.setToken userToken
        return cb null, token

  get_vk_info: (cb) ->
    fields = 'sex,city,country,photo_50'
    vk.request 'users.get', {user_id: '122263003', fields: fields}, (result) ->
      if result.error?
        return cb result.error
      cb null, result.response?[0]

module.exports = Strategy
