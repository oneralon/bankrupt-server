fs          = require 'fs-extra'
morgan      = require 'morgan'
dateFormat  = require 'dateformat'
time        = -> now = new Date(); dateFormat now, '[dd.m.yy HH:MM:ss]'
log         = fs.createWriteStream 'development.log', {flags: 'a'}

module.exports = morgan 'combined',
  stream: write: (str) ->
    log.write str

# module.exports.sql = (str) -> log.write "#{time()} SQL #{str}\n"
