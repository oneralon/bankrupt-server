mongoose   = require 'mongoose'
bcrypt     = require 'bcrypt'
generate   = require 'password-generator'
nodemailer = require 'nodemailer'

require '../models/user'
User      = mongoose.model 'User'
config    = require '../config/email'

exports.changepass = (req, res) ->
  old_pass  = req.body.old_pass  or req.query.old_pass
  new_pass1 = req.body.new_pass1 or req.query.new_pass1
  new_pass2 = req.body.new_pass2 or req.query.new_pass2
  if new_pass1 isnt new_pass2
    return res.status(400).json {err: 'Not match!'}
  if new_pass1.length < 6
    return res.status(400).json {err: 'Too short!'}
  email = new RegExp(req.user.email, 'i')
  User.findOne { email: { $regex: email } }, (err, user) =>
    return res.status(500).json {err: err} if err?
    if user?
      if bcrypt.compareSync old_pass, user.password
        user.password = bcrypt.hashSync new_pass1, 10
        user.save (err, user) =>
          return res.status(500).json {err: err} if err?
          res.status(200).send()
      else return res.status(400).json {err: 'Wrong password!'}
    else return res.status(404).json {err: 'User not found!'}

exports.restore = (req, res) ->
  email = req.body.email or req.query.email
  remail = new RegExp(email, 'i')
  User.findOne { email: { $regex: remail } }, (err, user) =>
    return res.status(500).json {err: err} if err?
    if user?
      hash1 = generate(16, false, /[ABCDEFGHJKLMNPQRSTUVWXYZ1-9]/)
      hash2 = generate(16, false, /[ABCDEFGHJKLMNPQRSTUVWXYZ1-9]/)
      url   = "http://mass-shtab.com:3000/api/user/confirm/#{hash1}/#{hash2}"
      user.restorehash = "#{hash1}:#{hash2}"
      user.save (err, user) =>
        res.status(500).json {err: err} if err?
        transporter = nodemailer.createTransport
          service: config.service
          auth: { user: config.user, pass: config.pass }
        email =
          from: "#{config.name} <#{config.user}>"
          to: email
          subject: "Восстановление доступа (Подтверждение)"
          text: "Для восстановления пароля перейдите по ссылке: #{url}"
          html: "Для восстановления пароля перейдите по ссылке: </br><a href='#{url}'>#{url}</a>"
        transporter.sendMail email, (err, info) =>
          res.status(500).json {err: err} if err?
          res.status(200).send()
    else res.status(400).json {err: 'Wrong email!'}

exports.confirm = (req, res) ->
  hash1 = req.body.hash1 or req.params.hash1
  hash2 = req.body.hash2 or req.params.hash2
  User.findOne { restorehash: "#{hash1}:#{hash2}" }, (err, user) =>
    return res.status(500).json {err: err} if err?
    if user?
        password = generate(8, false, /[ABCDEFGHJKLMNPQRSTUVWXYZ1-9]/)
        user.restorehash = ''
        user.password = bcrypt.hashSync password, 10
        user.save (err, user) =>
          res.status(500).json {err: err} if err?
          email =
            from: "#{config.name} <#{config.user}>"
            to: email
            subject: "Восстановление доступа"
            text: "Новый пароль: #{password}"
            html: "Новый пароль: #{password}"
          transporter.sendMail email, (err, info) =>
            res.status(500).json {err: err} if err?
            res.status(200).json {success: true}
    else res.status(400).json {err: 'Hash expired!'}