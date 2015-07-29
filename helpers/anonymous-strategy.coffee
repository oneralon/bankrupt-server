passport  = require 'passport-strategy'
util      = require 'util'
mongoose  = require 'mongoose'
moment    = require 'moment'

require '../models/user'
require '../models/license'

User      = mongoose.model 'User'
License   = mongoose.model 'License'

class Strategy extends passport.Strategy
  constructor: (params, verify) ->
    @name = 'anonymous'
    unless verify?
      verify = params
    @_verify = verify
    return

  authenticate: (req, options) ->
    device_id = req.device_id or req.query.device_id
    unless device_id?
      return @fail message: 'Missing device_id'
    user = User.findOne device: device_id, (err, result) =>
      if result?
        if result.anonymous
          if new Date() < result.license.end_date
            @success result
          else
            @success result
        else
          @fail()
      else
        License.findOne {name: 'demo'}, (err, license) =>
          if license?
            user = new User
              device: device_id
              licenses: [
                start_date: moment().format()
                end_date: moment().add(days: license.duration)
                license_type:
                  title: license.title
                  name: license.name
                  max_lots: license.max_lots
                  max_filters: license.max_filters
                  duration: license.duration
              ]
            user.save (err, user) =>
              @success user
          else
            @fail()

module.exports = Strategy
