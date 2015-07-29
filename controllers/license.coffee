exec      = require('child_process').exec
mongoose  = require 'mongoose'
moment    = require 'moment'

errors    = require '../helpers/error-codes'

require "../models/license"
require "../models/user"
require "../models/purchase"

User      = mongoose.model 'User'
License   = mongoose.model 'License'
Purchase  = mongoose.model 'Purchase'


exports.buy = (req, res) ->
  json = req.body.json or req.json or req.query.json
  data = JSON.parse json
  json = encodeURIComponent(json.replace /\s/ig, '+')
  sign = req.body.sign or req.sign or req.query.sign
  sign = encodeURIComponent(sign.replace /\s/ig, '+')
  child = exec "java -jar google_play_verify.jar #{sign} #{json}", (error, stdout, stderr) =>
    if error != null
      return res.status(500).json error

    verified = stdout.trim() is 'true'
    if verified
      Purchase.findOne {purchaseToken: data.purchaseToken}, (err, purchase) =>
        if err
          return res.status(500).json err
        unless purchase? and purchase.completed
          License.findOne {name: data.productId}, (err, license) =>
            if err
              return res.status(500).json err
            if license?
              if data.developerPayload
                req.user.promocodes = req.user.promocodes.filter (i) ->  i.code isnt data.developerPayload
              if req.user.licenses.length and req.user.licenses[req.user.licenses.length - 1].end_date > new Date() and req.user.licenses[req.user.licenses.length - 1].license_type.name isnt 'demo'
                req.user.licenses.push
                  start_date: req.user.licenses[req.user.licenses.length - 1].end_date
                  end_date: moment(req.user.licenses[req.user.licenses.length - 1].end_date)
                    .add(days: license.duration).toDate()
                  license_type:
                    title: license.title
                    name: license.name
                    max_lots: license.max_lots
                    max_filters: license.max_filters
                    duration: license.duration
              else
                req.user.licenses = [
                  start_date: new Date()
                  end_date: moment().add(days: license.duration).toDate()
                  license_type:
                    title: license.title
                    name: license.name
                    max_lots: license.max_lots
                    max_filters: license.max_filters
                    duration: license.duration
                ]
              if req.user.license.name is 'demo' then req.user.license = license

              req.user.save()

              if purchase?
                purchase.completed = yes
              else
                purchase = new Purchase data
              purchase.save()

              res.status(200).json data.purchaseToken
            else
              res.status(500).json errors.license_not_found
        else
          res.status(200).json data.purchaseToken
    else
      res.status(422).json errors.invalid_signature

