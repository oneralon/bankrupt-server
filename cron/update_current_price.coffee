_         = require 'lodash'
mongoose  = require 'mongoose'
CronJob   = require('cron').CronJob

require '../config/db'
require '../models/lot'
Lot       = mongoose.model 'Lot'

update_current_price = (done) ->
    console.log 'Cron job update_current_price started'
  stream = Lot.find().populate('trade').stream()

  stream.on 'data', (lot) ->
    current_interval = null
    unless _.isEmpty lot.intervals
      current_interval = lot.intervals[0]
      now = new Date()
      unless now > lot.intervals[lot.intervals.length - 1].interval_end_date
        for interval in lot.intervals
          if interval.interval_start_date < now < interval.interval_end_date
            current_interval = interval
            break
      else
        current_interval = lot.intervals[lot.intervals.length - 1]

    lot.current_sum = current_interval?.interval_price or lot.current_sum or lot.start_price

    lot.save()
  stream.on 'error', (err) ->
  stream.on 'close', ->
    console.log 'Cron job update_current_price done'

new CronJob '0 20 0 * * *', update_current_price, null, true
