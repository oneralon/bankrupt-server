express     = require 'express'
mongoose    = require 'mongoose'
_           = require 'lodash'
moment      = require 'moment'
fs          = require 'fs'
path        = require 'path'

renderer    = require '../helpers/render-docx'
mailer      = require '../helpers/mail-lots'

exports.get = (req, res, next) ->
  lot_ids   = req.ids     or req.query.ids
  email     = req.email   or req.query.email
  if _.isEmpty lot_ids
    return res.status(500).json err: 'ids must be defined'
  if _.isEmpty email
    return res.status(500).json err: 'email must be defined'
  renderer lot_ids, (err, folder) ->
    if err?
      return res.status(500).json err: err
    mailer
      mail_to: email
      ids: lot_ids
      attachments: [
        filename: 'attachment.pdf'
        path: path.join folder, 'compiled-template.pdf'
      ]
    , (err, result) ->
      if err?
        return res.status(500).json err: err
      res.status(200).json err: err, result: result
