passport  = require 'passport'
pass      = require '../modules/passport'
router    = require('express').Router()



router.post "/login", passport.authenticate("local"), (req, res) ->
  res.send()


module.exports = router
