bcrypt      = require 'bcrypt'
_           = require 'lodash'
mongoose    = require 'mongoose'

require '../models/user'

User        = mongoose.model 'User'

exports.update = (req, res) ->
  login     = req.login or req.query.login
  email     = req.email or req.query.email
  password  = req.password or req.query.password
  avatar    = req.avatar or req.query.avatar
  name      = req.name or req.query.name
  surname   = req.surname or req.query.surname

  unless _.isEmpty login
    req.user.login = login
  unless _.isEmpty email
    req.user.email = email
  unless _.isEmpty password
    req.user.password = bcrypt.hashSync password, 10
  unless _.isEmpty avatar
    req.user.avatar = avatar
  unless _.isEmpty name
    req.user.name = name
  unless _.isEmpty surname
    req.user.surname = surname

  req.user.save (err) ->
    if err?
      return res.status(500).json error: err
    res.status(200).json req.user
