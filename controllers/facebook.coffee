util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
FB        = require 'fb'
_         = require 'lodash'

config    = require "../config/db"
fb_config = require "../config/facebook"

require '../models/user'

User      = mongoose.model 'User'

check_fb = (fb_token, cb) ->
  FB.napi 'oauth/access_token',
    grant_type: 'fb_exchange_token'
    client_id: fb_config.app_id
    client_secret: fb_config.app_secret
    fb_exchange_token: fb_token
  , (err, res) ->
    if err?
      return cb err
    FB.setAccessToken res.access_token
    cb null, res

get_fb_info = (cb) ->
  FB.napi 'me', (err, user_info) ->
    if err?
      return cb err
    FB.napi 'me/picture',
      redirect: no,
      fields: ['url']
    , (err, res) ->
      if err
        return cb err
      user_info.avatar = res.data.url
      cb null, user_info

exports.attach = (req, res) ->
  fb_token  = req.fb_token  or req.query.fb_token
  check_fb fb_token, (err, result) ->
    if err?
      return res.status(500).send()
    get_fb_info (err, fb_info) ->
      if err?
        return res.status(500).send()
      User.find
        third_party_ids: facebook: fb_info.id
      , (err, fb_user) ->
        if err? or not _.isEmpty fb_user
          return res.status(500).send()
        req.user.third_party_ids.addToSet facebook: fb_info.id
        req.user.anonymous = no
        req.user.name = req.user.name or fb_info.first_name
        req.user.surname = req.user.surname or fb_info.last_name
        req.user.avatar = req.user.avatar or fb_info.avatar
        req.user.email = req.user.email or fb_info.email
        req.user.save (err, user) ->
          if err?
            return res.status(500).send()
          res.status(200).send()
