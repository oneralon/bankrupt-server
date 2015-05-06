mongoose      = require 'mongoose'

require '../models/user'

User          = mongoose.model 'User'

exports.create = (req, res) ->
  user = new User()

  user.save()
  res.status 200
    .send()
