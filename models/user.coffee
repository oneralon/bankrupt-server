mongoose            = require "mongoose"
Schema              = mongoose.Schema

userSchema = new Schema
  login: String
  email: String
  password: String
  avatar: String
  name: String
  surname: String
  anonymous:
    type: Boolean
    default: yes
  device: String
  activation_hash: String
  refers_count: Number
  activated:
    type: Boolean
    default: no
  license:
    title: String
    name: String
    max_lots: Number
    max_filters: Number
    duration: Number
  licenses: [
      start_date: Date
      end_date: Date
      license_type:
        type: Schema.Types.ObjectId
        ref: 'License'
    ]
  third_party_ids: [Schema.Types.Mixed]
  favourite_lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]
  hidden_lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]
  promocodes: [
    title: String
    code: String
    count: Number
    expiration: Date
    percent: Number
    description: String
    license:
      type: Schema.Types.ObjectId
      ref: 'License'
    license_name: String
  ]
  spent: [String]
  restorehash: String

mongoose.model 'User', userSchema
