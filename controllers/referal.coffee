mongoose    = require 'mongoose'
nodemailer  = require 'nodemailer'
ECT         = require 'ect'
moment      = require 'moment'
path        = require 'path'

mail_config = require '../config/email'
errors      = require '../helpers/error-codes'

require '../models/refer'
Refer = mongoose.model 'Refer'
require '../models/license'
License = mongoose.model 'License'

exports.mail = (req, res) ->
  email = req.email or req.query.email
  unless email
    return res.status(422).json errors.refer_empty_email

  renderer = ECT root : path.join __dirname, '../assets/mail'

  Refer.generate req.user, (err, refer) ->
    if err
      return res.status(500).json err
    refer.name = "#{req.user.name} #{req.user.surname}"
    html = renderer.render 'refer.ect', refer: refer

    transporter = nodemailer.createTransport(
      service: mail_config.service
      auth:
        user: mail_config.user
        pass: mail_config.pass)
    transporter.sendMail
      from: "#{mail_config.name} <#{mail_config.user}>"
      to: email
      subject: "#{refer.name} приглашает вас начать зарабатывать с помощью приложения «Охота на Банкрота»"
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

exports.activate = (req, res) ->
  bonus = req.bonus or req.query.bonus or req.body.bonus
  Refer.count sender: req.user, recipient: $ne: null, (err, refers) =>
    return res.status(500).json err if err?
    if bonus is 'gold'
      return res.status(400).json {err: 'Not enough money'} if refers < 25
      return res.status(400).json {err: 'Spent'} if req.user.spent.indexOf('gold') isnt -1
      License.findOne {name: 'prof_6'}, (err, license) =>
        return res.status(500).json err if err?
        if req.user.licenses.length and req.user.licenses[req.user.licenses.length - 1].end_date > new Date() and req.user.licenses[req.user.licenses.length - 1].license_type.name isnt 'demo'
          req.user.licenses.push
            start_date: req.user.licenses[req.user.licenses.length - 1].end_date
            end_date: moment(req.user.licenses[req.user.licenses.length - 1].end_date)
              .add(days: 30).toDate()
            license_type: license
        else
          req.user.licenses = [
            start_date: new Date()
            end_date: moment().add(days: 30).toDate()
            license_type: license
          ]
        req.user.spent.push 'gold'
        req.user.save (err) =>
          return res.status(500).json err if err?
          return res.status(200).send()
    else
      if bonus is 'silver'
        return res.status(400).json {err: 'Not enough money'} if refers < 10
        return res.status(400).json {err: 'Spent'} if req.user.spent.indexOf('silver') isnt -1
        License.findOne {name: 'demo'}, (err, license) =>
          return res.status(500).json err if err?
          if req.user.licenses.length and req.user.licenses[req.user.licenses.length - 1].end_date > new Date()
            req.user.licenses.push
              start_date: req.user.licenses[req.user.licenses.length - 1].end_date
              end_date: moment(req.user.licenses[req.user.licenses.length - 1].end_date)
                .add(days: 30).toDate()
              license_type: license
          else
            req.user.licenses = [
              start_date: new Date()
              end_date: moment().add(days: 30).toDate()
              license_type: license
            ]
          req.user.spent.push 'silver'
          req.user.save (err) =>
            return res.status(500).json err if err?
            return res.status(200).send()
        req.user.save (err) =>
          return res.status(500).json err if err?
          return res.status(200).send()
      else return res.status(400).json {err: 'Bad request'}