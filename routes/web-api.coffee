express       = require 'express'
mongoose      = require 'mongoose'
moment        = require 'moment'
_             = require 'lodash'
router        = require('express').Router()


cors          = require '../middlewares/cors'


short_cards   = require '../controllers/short_card'
full_cards    = require '../controllers/full_card'
etps          = require '../controllers/etps'
statuses      = require '../controllers/statuses'


mongoose.set 'debug', yes


router.use '/*', cors

router.get '/short-cards',    short_cards.list
router.get '/full-cards/:id', full_cards.get
router.get '/etps',           etps.get
router.get '/statuses',       statuses.get


module.exports = router
