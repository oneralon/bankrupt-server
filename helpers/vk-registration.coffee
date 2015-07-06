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
        console.log err
        return me.fail err
      console.log 'get vk user info'
      me.get_vk_info res.user_id, (err, user_info) ->
        console.log user_info
        if err?
          console.log err
          return me.fail err
        User.findOne
          device: device_id
        , (err, user) ->
          if err? or not user?
            console.log 'fail because err', err, user
            return me.fail err

          if user.third_party_ids.length > 0
            error = errors.auth_fail_social_exists
            return req.res.status(401).json
              error_code: error?.code
              error_message: error?.message

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
