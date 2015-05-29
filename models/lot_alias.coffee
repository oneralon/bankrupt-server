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

lotAliasSchema.index lot: 1
lotAliasSchema.index user: 1

mongoose.model 'LotAlias', lotAliasSchema
