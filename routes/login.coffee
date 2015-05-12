passport  = require 'passport'
pass      = require '../modules/passport'
router    = require('express').Router()


router.get "/login", (req, res) ->
  passport.authenticate('anonymous') req, res, () ->
    res.send()


module.exports = router
