mongoose            = require "mongoose"
Schema              = mongoose.Schema

userSchema = new Schema
  login: String
  email: String
  password: String
  devices: [String]


mongoose.model 'User', userSchema
