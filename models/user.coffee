mongoose            = require "mongoose"
Schema              = mongoose.Schema

userSchema = new Schema
  login: String
  email: String
  password: String
  device: String
  license:
    start_date: Date
    end_date: Date

  favourite_lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]


mongoose.model 'User', userSchema
