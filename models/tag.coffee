mongoose            = require "mongoose"
Schema              = mongoose.Schema

tagSchema = new Schema
  title: String
  keywords: Schema.Types.Mixed
  alone: Boolean
  system:
    type: Boolean
    default: false
  color: String
  user:
    type: Schema.Types.ObjectId
    ref: 'User'

tagSchema.index user: 1
tagSchema.index system: 1

mongoose.model 'Tag', tagSchema
