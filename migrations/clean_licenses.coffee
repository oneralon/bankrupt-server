require '../models/user'
require '../models/refer'
require '../models/license'
mongoose          = require 'mongoose'
config =
  host: 'localhost'
  port: 27017
  database: 'test-bankrot-parser'
  salt: 'keyboard cat'
unless mongoose.connection.readyState
  mongoose.connect "mongodb://#{config.host}:#{config.port}/#{config.database}"
User              = mongoose.model 'User'
Refer             = mongoose.model 'Refer'
License           = mongoose.model 'License'

User.find().populate('licenses.license_type').exec (err, users) =>
  License.find {name: 'demo'}, (err, demo) =>
  for user in users
    licenses = [demo]
    for license in user.licenses
      unless license.license_type is null then licenses.push license
    user.licenses = licenses
    user.save()