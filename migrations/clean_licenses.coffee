require '../models/user'
require '../models/refer'
require '../models/license'
Sync = require 'sync'
mongoose          = require 'mongoose'
config =
  host: 'localhost'
  port: 27017
  database: 'bankrot-parser'
  salt: 'keyboard cat'
unless mongoose.connection.readyState
  mongoose.connect "mongodb://#{config.host}:#{config.port}/#{config.database}"
User              = mongoose.model 'User'
Refer             = mongoose.model 'Refer'
License           = mongoose.model 'License'

User.find().populate('licenses.license_type').exec (err, users) =>

  License.find {name: 'demo'}, (err, demo) =>
    Sync =>
      for user in users
        now = new Date()
        far = new Date()
        far.setDate(far.getDate() + 14)
        licenses = [
          start_date: now
          end_date: far
          license_type: demo
        ]
        for license in user.licenses
          if license and license.license_type isnt null then licenses.push license
        user.licenses = licenses
        console.log user._id
          user.save.sync null