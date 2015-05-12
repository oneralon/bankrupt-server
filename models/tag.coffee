mongoose            = require "mongoose"
Schema              = mongoose.Schema

tagSchema = new Schema
  title: String
  keywords: Schema.Types.Mixed
  alone: Boolean
  system: Boolean
  color: String

mongoose.model 'Tag', tagSchema
