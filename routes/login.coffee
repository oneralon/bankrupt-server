passport  = require 'passport'
pass      = require '../modules/passport'
router    = require('express').Router()


router.get "/login", (req, res) ->
  console.log 'user: ', req.user
  passport.authenticate('anonymous') req, res, () ->
    console.log arguments
    console.log 'fasdfsad'
    console.log req.user
    res.send()


module.exports = router
