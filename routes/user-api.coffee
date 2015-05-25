passport    = require 'passport'
pass        = require '../modules/passport'
router      = require('express').Router()
mustBeAuth  = require '../middlewares/passport'
cors        = require '../middlewares/cors'


router.get '/login', (req, res) ->
  passport.authenticate(['registered', 'vk', 'facebook', 'twitter', 'linkedin', 'anonymous']) req, res, () ->
    device_id = req.device_id or req.query.device_id
    if req.user?
      req.user.device = device_id
      req.user.save()
    res.send()

router.get '/register', (req, res) ->
  passport.authenticate(['registration', 'vk-registration', 'facebook-registration', 'twitter-registration', 'linkedin-registration']) req, res, () ->
    res.send()

router.get '/activate', (req, res) ->
  passport.authenticate('activation') req, res, () ->
    res.send()



favourite_lots  = require '../controllers/favourite_lots'
filter_presets  = require '../controllers/filters'
upload_lots     = require '../controllers/upload_lots'

facebook        = require '../controllers/facebook'
vk              = require '../controllers/vk'
twitter         = require '../controllers/twitter'
linkedin        = require '../controllers/linkedin'



router.use mustBeAuth
router.use '/*', cors

router.get '/logout', (req, res) ->
  req.logOut()
  res.status(200).send()


router.get '/social/facebook/attach',   facebook.attach
router.get '/social/vk/attach',         vk.attach
router.get '/social/twitter/attach',    twitter.attach
router.get '/social/linkedin/attach',   linkedin.attach


router.get '/favourite-lots/add',       favourite_lots.add
router.get '/favourite-lots/get',       favourite_lots.get
router.get '/favourite-lots/delete',    favourite_lots.delete
router.get '/favourite-lots/setAlias',  favourite_lots.setAlias
router.get '/favourite-lots/addTag',    favourite_lots.addTag
router.get '/favourite-lots/removeTag', favourite_lots.removeTag
router.get '/favourite-lots/check',     favourite_lots.check

router.get '/filter_presets/add',       filter_presets.add
router.get '/filter_presets/get/:preset_id',  filter_presets.get
router.get '/filter_presets/get',       filter_presets.get_all
router.get '/filter_presets/set',       filter_presets.set
router.get '/filter_presets/delete',    filter_presets.delete

router.get '/upload_lots/',             upload_lots.get

module.exports = router
