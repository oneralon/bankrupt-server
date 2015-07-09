mongoose            = require "mongoose"
Schema              = mongoose.Schema

purchaseSchema = new Schema
  packageName: String
  productId: String
  purchaseTime: Number
  purchaseState: Number
  developerPayload: String
  purchaseToken: String
  autoRenewing: Boolean
  completed:
    type: Boolean
    dafault: false

mongoose.model 'Purchase', purchaseSchema
