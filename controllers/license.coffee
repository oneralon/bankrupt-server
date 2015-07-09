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

  console.log req.body.json
  console.log req.json

  child = exec "java -jar google_play_verify.jar #{sign} #{json}", (error, stdout, stderr) ->
    if error != null
      return res.status(500).json error

    verified = stdout.trim() is 'true'
    if verified
      Purchase.findOne {purchaseToken: data.purchaseToken}, (err, purchase) ->
        if err
          return res.status(500).json err
        unless purchase? and purchase.completed
          License.findOne {name: data.productId}, (err, license) ->
            if err
              return res.status(500).json err
            if license?
              req.user.license.license_type = license
              req.user.license.start_date = new Date()
              req.user.license.end_date = moment().add(days: license.duration).toDate()

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

