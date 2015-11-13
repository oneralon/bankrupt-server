mongoose            = require "mongoose"
Schema              = mongoose.Schema

licenseTypeSchema = new Schema
  title: String #free/prof/individual
  options: Schema.Types.Mixed # {
  #   "unloading":{"quantity":-1,"day":-1},
  #   "favorits":{"size":300},
  #   "push":1,
  #   "filters":{"size":15},
  #   "advertising":0
  # }

mongoose.model 'LicenseType', licenseTypeSchema