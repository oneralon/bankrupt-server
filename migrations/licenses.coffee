mongoose = require 'mongoose'

require '../models/license'
License   = mongoose.model 'License'

mongoose.connect 'mongodb://127.0.0.1:27017/bankrot-parser', ->
  mongoose.connection.collection('licenses').insert [
      title: 'тест 1'
      name: 'test1001'
      duration: 30
  ,
      title: 'тест 2'
      name: 'test_billing'
      duration: 60
  ]
  , (err) ->
    console.log err
    mongoose.connection.close()
