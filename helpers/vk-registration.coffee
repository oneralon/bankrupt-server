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
    @name = 'vk-registration'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    vk_token  = req.vk_token  or req.query.vk_token
    email     = req.email     or req.query.email
    unless device_id? and vk_token?
      return @fail()
    console.log 'get vk long token'
    me = @
    @check_vk vk_token, (err, res) ->
      if err?
        return me.fail err
      console.log 'get vk user info'
      me.get_vk_info (err, user_info) ->
        console.log user_info
        if err?
          return me.fail err
        User.findOne
          device: device_id
        , (err, user) ->
          if err? or not user?
            console.log 'fail because err', err, user
            return me.fail err
          User.findOne
            third_party_ids: vk: user_info.id
          , (err, vk_user) ->
            console.log err, vk_user
            if err or vk_user?
              return me.fail err
            user.third_party_ids.addToSet vk: user_info.id
            user.anonymous = no
            user.name = user_info.first_name
            user.surname = user_info.last_name
            user.avatar = user_info.photo_50
            user.email = email
            user.save (err, res) ->
              if err?
                return me.fail err
              return me.success()

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
