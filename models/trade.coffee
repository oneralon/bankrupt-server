mongoose            = require "mongoose"
Schema              = mongoose.Schema

tradeSchema = new Schema
  price_submission_type: String
  holding_date: Date
  title: String
  trade_type: String
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
  owner:
    short_name: String
    full_name: String
    inn: String
    internet_address: String
    contact:
      name: String
      fax: String
      phone: String
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
  etp:
    href: String
    name: String
  type: String
  documents: [
    name: String
    url: String
  ]
  lots: [
    type: Schema.Types.ObjectId
    ref: 'Lot'
  ]

mongoose.model 'Trade', tradeSchema
