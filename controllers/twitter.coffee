util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
_         = require 'lodash'
Twitter   = require 'twitter'

config    = require '../config/db'
tw_config = require '../config/twitter'

require '../models/user'

User      = mongoose.model 'User'

check_tw = (token, secret, cb) ->
  client = new Twitter
    consumer_key: tw_config.consumer_key
    consumer_secret: tw_config.consumer_secret
    access_token_key: token
    access_token_secret: secret

  client.get "account/verify_credentials", (error, details) ->
    unless _.isEmpty error
      return cb error
    cb null, details

exports.attach = (req, res) ->
  tw_token  = req.tw_token  or req.query.tw_token
  tw_secret = req.tw_secret or req.query.tw_secret
  check_tw tw_token, tw_secret, (err, tw_info) ->
    if err?
      return res.status(500).send()
    User.find
      third_party_ids: twitter: tw_info.id
    , (err, tw_user) ->
      if err? or not _.isEmpty tw_user
        console.log err, tw_user
        return res.status(500).send()
      req.user.third_party_ids.addToSet twitter: tw_info.id
      req.user.anonymous = no
      req.user.name = req.user.name or tw_info.name.split(' ')?[0]
      req.user.surname = req.user.surname or tw_info.name.split(' ')?[1]
      req.user.avatar = req.user.avatar or tw_info.profile_image_url
      req.user.email = req.user.email or tw_info.email
      req.user.save (err, user) ->
        if err?
          return res.status(500).send()
        res.status(200).send()
