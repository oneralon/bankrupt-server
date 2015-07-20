passport    = require 'passport'
moment      = require 'moment'
mongoose    = require 'mongoose'
pass        = require '../modules/passport'
router      = require('express').Router()
mustBeAuth  = require '../middlewares/passport'
cors        = require '../middlewares/cors'

require '../models/refer'
require '../models/license'
Refer = mongoose.model 'Refer'
License = mongoose.model 'License'


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
          License.findOne name: 'prof', title: 'prof', duration: 14, (err, license) ->
            if license?
              now = new Date()
              req.user.licenses.unshift
                start_date: now
                end_date: moment().add({days: license.duration}).toDate()
                license_type: license
              for i in [1..req.user.licenses.length - 1]
                duration = req.user.licenses[i].end_date - Math.max(now, req.user.licenses[i].start_date)
                req.user.licenses[i].start_date = req.user.licenses[i - 1].end_date
                req.user.licenses[i].end_date = moment(req.user.licenses[i].start_date).add(ms: duration, days: 7).toDate()
              refer.recipient = req.user
              refer.save()
              req.user.save (err) ->
                res.json req.user
    else
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
router.post '/refer/get',               referal.get
router.get  '/refer/get',               referal.get

module.exports = router
