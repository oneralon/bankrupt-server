mongoose  = require 'mongoose'
config    = require '../config/db'
require '../models/license'
License   = mongoose.model 'License'

mongoose.connect "mongodb://127.0.0.1:27017/#{config.database}", ->
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
      title: 'prof_6'
      name: 'prof_6'
      duration: 30 * 6
      max_lots: 300
      max_filters: 999
  ,
      title: 'prof_9'
      name: 'prof_9'
      duration: 30 * 9
      max_lots: 300
      max_filters: 999
  ,
      title: 'prof_12'
      name: 'prof_12'
      duration: 30 * 12
      max_lots: 300
      max_filters: 999
  ,
      title: 'default'
      name: 'default'
      max_lots: 3
      max_filters: 3
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
