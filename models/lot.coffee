mongoose            = require "mongoose"
Schema              = mongoose.Schema

lotSchema = new Schema
  number: Number
  currency: String
  title: String
  start_price: Number
  current_sum: Number
  discount: Number
  discount_percent: Number
  status: String
  price_reduction_type: String
  procedure: String
  information: String
  step_percent: Number
  step_sum: Number
  category: String
  calc_method: String
  bank_name: String
  deposit_size: Number
  payment_account: String
  deposit_payment_date: String
  correspondent_account: String
  deposit_return_date: String
  bik: String
  deposit_procedure: String
  url: String
  last_message: Date
  region: String
  documents: [
    name: String
    url: String
  ]
  intervals: [
    interval_start_date: Date
    request_start_date: Date
    request_end_date: Date
    interval_end_date: Date
    price_reduction_percent: Number
    deposit_sum: Number
    interval_price: Number
    comment: String
  ]
  tagInputs: [
    input: String
    match: String
  ]
  trade:
    type: Schema.Types.ObjectId
    ref: 'Trade'
  tags: [
    type: Schema.Types.ObjectId
    ref: 'Tag'
  ]

lotSchema.index {title: 'text', information: 'text'}, { default_language: "russian" }
# lotSchema.set 'autoIndex', false

mongoose.model 'Lot', lotSchema
