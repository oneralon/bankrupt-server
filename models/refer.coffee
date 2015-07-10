mongoose    = require "mongoose"
Schema      = mongoose.Schema
crypto      = require 'crypto'

referSchema = new Schema
  code: String
  sender:
    type: Schema.Types.ObjectId
    ref: 'User'
  recipient:
    type: Schema.Types.ObjectId
    ref: 'User'

referSchema.statics.generate = (user, cb) ->
  unless user?
    return cb new Error('Try to generate refer without user')
  crypto.randomBytes 4, (err, buf) =>
    if err
      return cb err
    token = buf.toString 'hex'

    refer = new @
      sender: user
      code: token

    refer.save (err) ->
      if err
        return cb err
      cb null, refer

mongoose.model 'Refer', referSchema
