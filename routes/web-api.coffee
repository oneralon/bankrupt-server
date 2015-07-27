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
error_logs    = require '../controllers/error_logs'
promocode     = require '../controllers/promocode'

mongoose.set 'debug', yes

router.use '/*', cors

router.get '/log',            error_logs.add

router.get '/etps',           etps.get
router.get '/statuses',       statuses.get
router.get '/regions',        regions.get

router.get '/tags',           tags.get

router.get '/promocode/create', promocode.create
router.post '/promocode/generate', promocode.generate

router.use mustBeAuth

router.get '/tags/update',    tags.update
router.get '/tags/add',       tags.add
router.get '/tags/delete',    tags.delete
router.get '/short-cards',    short_cards.list
router.get '/full-cards/:id', full_cards.get

router.get '/promocode/create', promocode.create
router.post '/promocode/generate', promocode.generate


module.exports = router
