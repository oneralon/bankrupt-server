mongoose            = require "mongoose"
Schema              = mongoose.Schema

licenseSchema = new Schema
  title: String
  name: String
  max_lots: Number
  max_filters: Number
  duration: Number # days

mongoose.model 'License', licenseSchema
