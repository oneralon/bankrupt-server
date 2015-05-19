fs              = require 'fs'
mongoose        = require 'mongoose'
path            = require 'path'
ECT             = require 'ect'
child_process   = require 'child_process'
_               = require 'lodash'
moment          = require 'moment'
countdown       = require 'countdown'

require 'moment-countdown'

moment.locale 'ru'

require '../models/lot'
require '../models/trade'
require '../models/tag'

Lot       = mongoose.model 'Lot'
Trade     = mongoose.model 'Trade'
Tag       = mongoose.model 'Tag'

countdown.resetLabels()
countdown.setLabels(
  ' миллисекунда| секунда| минута| час| день| неделя| месяц| год| декада| век| эпоха',
  ' миллисекунд| секунд| минут| часов| дней| недель| месяцев| лет| декад| веков| эпох',
  ' и ',
  ', ',
  '')
module.exports = (lot_ids, cb) ->
  Lot.find(_id: $in: lot_ids).populate('trade').populate('tags').exec (err, lots) ->
    if err?
      console.error err
      return cb err
    renderer = ECT root : path.join __dirname, '../assets/docs'

    lots.forEach (item) ->
      if item.title.substr(0, 99) isnt item.title
        item.title = item.title.substr(0, 99) + '...'
      unless _.isEmpty item.intervals
        current_interval = item.intervals[0]
        unless new Date() > item.intervals[item.intervals.length - 1].interval_end_date
          date = new Date()
          for interval in item.intervals
            if interval.interval_start_date < date < interval.interval_end_date
              current_interval = interval
              break

          nextInterval = item.intervals[item.intervals.indexOf(current_interval) + 1] or undefined
          if nextInterval?
            duration = moment(nextInterval.interval_start_date)

      end_date = moment(item.trade.requests_end_date or
        item.intervals[item.intervals.length - 1]?.request_end_date or
        item.trade.holding_date or
        item.trade.results_date)

      if duration?
        item.next_interval_transcription = countdown(duration.toDate(), new Date(), countdown.DEFAULTS, 2).toString()
        item.next_interval = duration
      if end_date?
        item.end_date = end_date
        item.end_date_transcription = countdown(end_date, Date(), countdown.DEFAULTS, 2).toString()

      item.tags.forEach (tag) ->
        tag.color = tag.color.toLowerCase().replace '#', ''


    tex = renderer.render 'template.tex',
      lots: lots

    time = new Date().getTime()

    dir_name = path.join __dirname, '../assets/docs/letter' + time

    fs.mkdirSync dir_name

    fs.writeFileSync path.join(dir_name, 'compiled-template.tex'), tex

    child_process.exec "pdflatex -output-directory=#{dir_name} #{path.join(dir_name, 'compiled-template.tex')}"
    , (err, stdout, stderr) ->
      if err?
        return cb err
      child_process.exec "pdflatex -output-directory=#{dir_name} #{path.join(dir_name, 'compiled-template.tex')}"
      , (err, stdout, stderr) ->
        if err?
          return cb err
        cb null, dir_name
