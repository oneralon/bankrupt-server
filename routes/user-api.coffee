passport    = require 'passport'
pass        = require '../modules/passport'
router      = require('express').Router()
mustBeAuth  = require '../middlewares/passport'


router.get '/login', (req, res) ->
  passport.authenticate('anonymous') req, res, () ->
    res.send()

router.use mustBeAuth

favourite_lots = require '../controllers/favourite_lots'

router.get '/favourite-lots/add',   favourite_lots.add
router.get '/favourite-lots/check', favourite_lots.check

module.exports = router
