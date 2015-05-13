mongoose            = require "mongoose"
Schema              = mongoose.Schema

filterPresetSchema = new Schema
  user:
    type: Schema.Types.ObjectId
    ref: 'User'
  content: Schema.Types.Mixed

mongoose.model 'FilterPreset', filterPresetSchema
