mongoose            = require "mongoose"
Schema              = mongoose.Schema

tradeSchema = new Schema
  holding_date: Date
  title: String
  type: String
  trade_type: String
  membership_type: String
  price_submission_type: String
  requests_start_date: Date
  additional: String
  requests_end_date: Date
  win_procedure: String
  official_publish_date: Date
  submission_procedure: String
  print_publish_date: Date
  bankrot_date: Date
  results_place: String
  contract_signing_person: String
  number: String
  url: String
  region: String
  last_message: Date
  owner:
    short_name: String
    full_name: String
    inn: String
    internet_address: String
    contact:
      name: String
      fax: String
      phone: String
      _id: false
    _id: false
  debtor:
    debtor_type: String
    arbitral_name: String
    inn: String
    bankruptcy_number: String
    short_name: String
    arbitral_commissioner: String
    full_name: String
    arbitral_organization: String
    ogrn: String
    contract_procedure: String
    judgment: String
    payment_terms: String
    reviewing_property: String
    region: String
    _id: false
  etp:
    href: String
    name: String
    _id: false
  documents: [
    name: String
    url: String
    _id: false
  ]
  lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]
,
  versionKey: false

mongoose.model 'Trade', tradeSchema
