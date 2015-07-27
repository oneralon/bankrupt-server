mongoose            = require "mongoose"
Schema              = mongoose.Schema

promocodeSchema = new Schema
  title: String
  code: String
  count: Number
  expiration: Date
  license:
    type: Schema.Types.ObjectId
    ref: 'License'

mongoose.model 'Promocode', promocodeSchema