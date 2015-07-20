mongoose    = require 'mongoose'
nodemailer  = require 'nodemailer'
ECT         = require 'ect'
moment      = require 'moment'
path        = require 'path'

mail_config = require '../config/email'
errors      = require '../helpers/error-codes'

require '../models/refer'
Refer = mongoose.model 'Refer'

exports.mail = (req, res) ->
  email = req.email or req.query.email
  unless email
    return res.status(422).json errors.refer_empty_email

  renderer = ECT root : path.join __dirname, '../assets/mail'

  Refer.generate req.user, (err, refer) ->
    if err
      return res.status(500).json err
    html = renderer.render 'refer.ect', refer: refer

    transporter = nodemailer.createTransport(
      service: mail_config.service
      auth:
        user: mail_config.user
        pass: mail_config.pass)
    transporter.sendMail
      from: "#{mail_config.name} <#{mail_config.user}>"
      to: email
      subject: 'Вас пригласили воспользоваться приложением'
      html: html
    , (err, result) ->
      if err
        return res.status(500).json err

      res.status(200).json result

exports.get = (req, res) ->
  Refer.generate req.user, (err, refer) ->
    if err
      return res.status(500).json err
    return res.status(200).json refer
