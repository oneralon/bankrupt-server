mongoose    = require 'mongoose'
nodemailer  = require 'nodemailer'
ECT         = require 'ect'
moment      = require 'moment'
path        = require 'path'

mail_config = require '../config/email'

require '../models/lot'

Lot         = mongoose.model 'Lot'


module.exports = (params, cb) ->
  Lot.find _id: $in: params.ids, (err, lots) ->
    renderer = ECT root : path.join __dirname, '../views'
    html = renderer.render 'upload_lots.ect',
      lots: lots
    transporter = nodemailer.createTransport(
      service: mail_config.service
      auth:
        user: mail_config.user
        pass: mail_config.pass)
    transporter.sendMail
      from: mail_config.user
      to: params.mail_to
      subject: 'Выгрузка данных от ' + moment().format 'DD.MM.YYYY hh:mm'
      html: html
      attachments: params.attachments if params.attachments?
    , cb
