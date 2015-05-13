mongoose            = require "mongoose"
Schema              = mongoose.Schema

lotAliasSchema = new Schema
  title: String
  lot:
    type: Schema.Types.ObjectId
    ref: 'Lot'
  user:
    type: Schema.Types.ObjectId
    ref: 'User'

mongoose.model 'LotAlias', lotAliasSchema
