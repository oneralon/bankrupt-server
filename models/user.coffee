mongoose            = require "mongoose"
Schema              = mongoose.Schema

userSchema = new Schema
  login: String
  email: String
  password: String
  anonymous:
    type: Boolean
    default: yes
  device: String
  activation_hash: String
  activated: Boolean
  license:
    start_date: Date
    end_date: Date

  favourite_lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]


mongoose.model 'User', userSchema
