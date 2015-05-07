passport  = require 'passport'
pass      = require '../modules/passport'
router    = require('express').Router()


router.post "/login", (req, res) ->
  passport.authenticate('anonymous') req, res, () ->
    console.log 'fasdfsad'
    console.log req.user
    res.send()


module.exports = router
