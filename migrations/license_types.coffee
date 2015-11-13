mongoose  = require 'mongoose'
config    = require '../config/db'
require '../models/license_type'
LicenseType   = mongoose.model 'LicenseType'

mongoose.connect "mongodb://127.0.0.1:27017/#{config.database}", ->
  mongoose.connection.collection('licensetypes').insert [
    name: 'free'
    options:
      unloading: { quantity: -1, day:-1 }
      favorits: { size: 25 }
      push: 1
      filters: { size: 4 }
      advertising: 1
  ,
    name: 'pro'
    options:
      unloading: { quantity: -1, day:-1 }
      favorits: { size: 300 }
      push: 1
      filters: { size: 4 }
      advertising: 0
  ]
  , (err, info) ->
    console.log err or info
    mongoose.connection.close()