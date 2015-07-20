mongoose = require 'mongoose'

require '../models/license'
License   = mongoose.model 'License'

mongoose.connect 'mongodb://127.0.0.1:27017/bankrot-parser', ->
  mongoose.connection.collection('licenses').insert [
      title: 'тест 1'
      name: 'test1001'
      duration: 30
      max_lots: 300
      max_filters: 999
  ,
      title: 'тест 2'
      name: 'test_billing'
      duration: 60
      max_lots: 300
      max_filters: 999
  ,
      title: 'demo'
      name: 'demo'
      duration: 7
      max_lots: 25
      max_filters: 3
  ,
      title: 'demo'
      name: 'demo'
      duration: 14
      max_lots: 25
      max_filters: 3
  ,
      title: 'prof'
      name: 'prof'
      duration: 14
      max_lots: 300
      max_filters: 999
  ]
  , (err) ->
    console.log err
    mongoose.connection.close()
