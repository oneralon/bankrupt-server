express       = require 'express'
mongoose      = require 'mongoose'
moment        = require 'moment'
_             = require 'lodash'
router        = require('express').Router()
mustBeAuth    = require '../middlewares/passport'


cors          = require '../middlewares/cors'


short_cards   = require '../controllers/short_card'
full_cards    = require '../controllers/full_card'
etps          = require '../controllers/etps'
statuses      = require '../controllers/statuses'
regions       = require '../controllers/regions'
tags          = require '../controllers/tags'


mongoose.set 'debug', yes

router.use '/*', cors

router.get '/etps',           etps.get
router.get '/statuses',       statuses.get
router.get '/regions',        regions.get
router.get '/tags',           tags.get

router.use mustBeAuth

router.get '/short-cards',    short_cards.list
router.get '/full-cards/:id', full_cards.get


module.exports = router
