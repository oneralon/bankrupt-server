util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'
_         = require 'lodash'
Linkedin  = require 'node-linkedin'

config    = require '../config/db'
li_config = require '../config/linkedin'

require '../models/user'

User      = mongoose.model 'User'

Linkedin  = Linkedin li_config.cliend_id, li_config.client_secret

check_li = (access_token, cb) ->
  linkedin = Linkedin.init access_token
  linkedin.people.me (err, me) ->
    if me.errorCode?
      return cb me
    cb null, me

exports.attach = (req, res) ->
  li_token  = req.li_token  or req.query.li_token
  check_li li_token, (err, li_info) ->
    if err?
      return res.status(500).send()
    User.find
      third_party_ids: linkedin: li_info.id
    , (err, li_user) ->
      if err? or not _.isEmpty li_user
        return res.status(500).send()
      req.user.third_party_ids.addToSet linkedin: li_info.id
      req.user.anonymous = no
      req.user.name = req.user.name or li_info.firstName
      req.user.surname = req.user.surname or li_info.lastName
      req.user.avatar = req.user.avatar or li_info.pictureUrl
      req.user.email = req.user.email or li_info.emailAddress
      req.user.save (err, user) ->
        if err?
          return res.status(500).send()
        res.status(200).send()
