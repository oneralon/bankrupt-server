mongoose  = require 'mongoose'
config    = require '../config/db'
require '../models/license'
License   = mongoose.model 'License'

mongoose.connect "mongodb://127.0.0.1:27017/#{config.database}", ->
  mongoose.connection.collection('licenses').insert [
      title: 'PRO 6 месяцев'
      name: 'prof_6'
      duration: 30 * 6
      max_lots: 300
      max_filters: 999
  ,
      title: 'PRO 9 месяцев'
      name: 'prof_9'
      duration: 30 * 9
      max_lots: 300
      max_filters: 999
  ,
      title: 'PRO 12 месяцев'
      name: 'prof_12'
      duration: 30 * 12
      max_lots: 300
      max_filters: 999
  ,
      title: 'PRO 6 месяцев -50%'
      name: 'prof_6m_50p'
      duration: 30 * 6
      max_lots: 300
      max_filters: 999
  ,
      title: 'PRO 12 месяцев -40%'
      name: 'prof_12m_40p'
      duration: 30 * 12
      max_lots: 300
      max_filters: 999
  ,
      title: 'Демо'
      name: 'demo'
      duration: 14
      max_lots: 25
      max_filters: 3
  ,
      title: 'PRO 2 недели'
      name: 'prof'
      duration: 14
      max_lots: 300
      max_filters: 999
  ]
  , (err) ->
    console.log err
    mongoose.connection.close()
