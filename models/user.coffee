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
    start_date: Date
    end_date: Date
    license_type:
      type: Schema.Types.ObjectId
      ref: 'Lot'
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



mongoose.model 'User', userSchema
