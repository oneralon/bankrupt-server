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


mongoose.model 'User', userSchema
