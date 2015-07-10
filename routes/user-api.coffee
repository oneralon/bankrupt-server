passport    = require 'passport'
moment      = require 'moment'
mongoose    = require 'mongoose'
pass        = require '../modules/passport'
router      = require('express').Router()
mustBeAuth  = require '../middlewares/passport'
cors        = require '../middlewares/cors'

require '../models/refer'
Refer = mongoose.model 'Refer'


router.get '/login', (req, res) ->
  passport.authenticate(['registered', 'vk', 'google', 'facebook', 'twitter', 'linkedin', 'odnoklassniki', 'anonymous']) req, res, () ->
    console.log 'there', req.user
    if req.user?
      device_id = req.device_id or req.query.device_id
      req.user.device = device_id
      req.user.save()
    res.send()

router.get '/register', (req, res) ->
  passport.authenticate(['registration', 'google-registration', 'vk-registration', 'facebook-registration', 'twitter-registration', 'linkedin-registration', 'odnoklassniki-registration']) req, res, () ->
    console.log 'registered', arguments
    refer_code = req.refer_code or req.query.refer_code
    if req.user? and refer_code?
      Refer.findOne code: refer_code, (err, refer) ->
        if err
          req.res.status(500).json err
        if refer
          req.user.licenses[req.user.licenses.length - 1].end_date =
            moment(req.user.licenses[req.user.licenses.length - 1].end_date).add(days: 14).toDate()
          refer.recipient = req.user
          refer.save()
          req.user.save()

    console.log
    res.send()

router.get '/activate', (req, res) ->
  passport.authenticate('activation') req, res, () ->
    res.send()




favourite_lots  = require '../controllers/favourite_lots'
hidden_lots     = require '../controllers/hidden_lots'
filter_presets  = require '../controllers/filters'
upload_lots     = require '../controllers/upload_lots'
profile         = require '../controllers/profile'
license         = require '../controllers/license'
referal         = require '../controllers/referal'

facebook        = require '../controllers/facebook'
vk              = require '../controllers/vk'
twitter         = require '../controllers/twitter'
linkedin        = require '../controllers/linkedin'



router.use mustBeAuth
router.use '/*', cors

router.get '/me', (req, res) ->
  res.status(200).json req.user


router.get '/logout', (req, res) ->
  req.logOut()
  res.status(200).send()

router.get '/update',                   profile.update

router.get '/social/facebook/attach',   facebook.attach
router.get '/social/vk/attach',         vk.attach
router.get '/social/twitter/attach',    twitter.attach
router.get '/social/linkedin/attach',   linkedin.attach


router.get '/hidden-lots/add',          hidden_lots.add
router.get '/hidden-lots/delete',       hidden_lots.delete

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

router.post '/license/buy',             license.buy

router.post '/refer/mail',              referal.mail
router.get  '/refer/mail',              referal.mail

module.exports = router
