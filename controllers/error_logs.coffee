express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'
nodemailer = require 'nodemailer'
config     = require '../config/email'

require '../models/user'
require '../models/error_log'
require '../models/report'

User        = mongoose.model 'User'
ErrorLog    = mongoose.model 'ErrorLog'
Report      = mongoose.model 'Report'

transporter = nodemailer.createTransport
  service: config.service
  auth: { user: config.user, pass: config.pass }

exports.add = (req, res, next) ->
  content   = req.query.content or req.content
  unless content?
    return res.status(500).json err: 'content must be defined'
  error_log = new ErrorLog
    user: req.user or undefined
    content: content
    date: new Date()
  error_log.save (err, error_log) ->
    if err?
      return res.status(500).json err: err
    return res.status(200).json id: error_log._id

exports.report = (req, res, next) ->
  content   = JSON.parse req.query.content or req.content or req.body.content
  unless content?
    return res.status(500).json err: 'Content need to be filled'
  else
    date = new Date()
    report = new Report
      date: date
      content: content
      user: req.user or undefined
    report.save (err, report) ->
      if err? then return res.status(500).json err: err
      email =
        from: "#{config.name} <#{config.user}>"
        to: 'support@mass-shtab.com'
        subject: "Сообщение о проблеме"
        text: """
          Описание проблемы: #{content.message}
          Модель устройства: #{content.device_model}
          Версия Android: #{content.os_version}
          Email: #{content.email or 'Не указан'}
          Дата: #{date}
        """
        html: """
          Описание проблемы: #{content.message}<br>
          Модель устройства: #{content.device_model}<br>
          Версия Android: #{content.os_version}<br>
          Email: #{content.email or 'Не указан'}<br>
          Дата: #{date}
        """
      transporter.sendMail email, (err, info) =>
        return res.status(500).json {err: err} if err?
        return res.status(200).json ticket_id: report._id