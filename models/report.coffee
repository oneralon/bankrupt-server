mongoose            = require "mongoose"
Schema              = mongoose.Schema

reportSchema = new Schema
  date: Date
  user:
    type: Schema.Types.ObjectId
    ref: 'User'
  content: Schema.Types.Mixed

mongoose.model 'Report', reportSchema