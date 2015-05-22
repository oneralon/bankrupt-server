util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
_         = require 'lodash'
VK        = require 'vksdk'

config    = require "../config/db"
vk_config = require "../config/vk"

require '../models/user'

User      = mongoose.model 'User'

vk        = new VK
  appId: vk_config.app_id
  appSecret: vk_config.app_secret
  language: 'ru'

check_vk = (token, cb) ->
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

get_vk_info = (user_id, cb) ->
  fields = 'sex,city,country,photo_50'
  vk.request 'users.get', {user_id: user_id, fields: fields}, (result) ->
    if result.error?
      return cb result.error
    cb null, result.response?[0]

exports.attach = (req, res) ->
  vk_token  = req.vk_token  or req.query.vk_token
  check_vk vk_token, (err, result) ->
    if err?
      console.log err, result
      return res.status(500).send()
    get_vk_info result.user_id, (err, vk_info) ->
      if err?
        console.log err, vk_info
        return res.status(500).send()
      User.find
        third_party_ids: vk: vk_info.id
      , (err, vk_user) ->
        if err? or not _.isEmpty vk_user
          console.log err, vk_user
          return res.status(500).send()
        req.user.third_party_ids.addToSet vk: vk_info.id
        req.user.anonymous = no
        req.user.name = req.user.name or vk_info.first_name
        req.user.surname = req.user.surname or vk_info.last_name
        req.user.avatar = req.user.avatar or vk_info.photo_50
        req.user.email = req.user.email or vk_info.email
        req.user.save (err, user) ->
          if err?
            console.log err
            return res.status(500).send()
          res.status(200).send()
