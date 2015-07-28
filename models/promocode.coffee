mongoose            = require "mongoose"
Schema              = mongoose.Schema
Sync                = require 'sync'

promocodeSchema = new Schema
  title: String
  description: String
  code: { type: String, unique: true }
  percent: Number
  count: Number
  expiration: Date
  license:
    type: Schema.Types.ObjectId
    ref: 'License'
  license_name: String

promocodeSchema.statics.generate = (count, options, cb) ->
  generate = ->
    code = ''
    alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'K', 'L', 'M', 'N',
                'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '2',
                '3', '4', '5', '6', '7', '8', '9']
    while code.length < 6
      letter = alphabet[Math.round(Math.random() * alphabet.length)]
      code += letter if letter
    code
  insert = (options, cb) =>
    console.log options
    options._id = mongoose.Types.ObjectId()
    mongoose.connection.collection('promocodes').insert options, (err) =>
      if err? and err.code is 11000 then cb null, false
      unless err? then cb null, options.code
      else cb err
  codes = []
  Sync =>
    while count > 0
      options.code = generate()
      result = insert.sync null, options
      if result isnt false
        count = count - 1
        codes.push result
    cb null, codes

mongoose.model 'Promocode', promocodeSchema