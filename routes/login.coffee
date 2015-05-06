passport  = require 'passport'
pass      = require '../modules/passport'
login     = require '../controllers/web-login'
router    = require('express').Router()

router.get '/', (req, res, next) ->
  if req.isAuthenticated()
    if req.user.role is 'admin' then res.redirect '/code'
    else res.redirect '/dashboard'
  else res.redirect '/login'

router.get '/login', (req, res, next) ->
  if req.isAuthenticated() then res.redirect '/'
  else res.render 'login/login.jade', {gettext: req.gettext, email: ''}

router.post '/login', (req, res, next) ->
  if req.isAuthenticated() then res.redirect '/'
  else
    if req.body.email is '" or req.body.password is "'
      req.flash 'error', req.gettext('Enter correct email and password')
      res.render 'login/login.jade',
        gettext: req.gettext
    else
      role = if req.body.role is 'admin' then 'admin' else 'operator'
      passport.authenticate(role,
        failureRedirect: '/login'
        failureFlash: req.gettext('Incorrect email or password')
      )(req, res, next)
,
  (req, res, next) ->
    req.user.sid = req.sessionID
    req.user.save().then ->
      res.redirect '/'
    .catch (err) ->
      req.flash 'error', req.gettext('Session store error')
      req.logout()
      res.redirect '/login'

router.get '/logout', (req, res, next) ->
  req.logout()
  req.flash 'success', req.gettext('Logout success')
  res.redirect '/login'

router.get  '/register', login.register
router.post '/register', login.adminCreate
router.get  '/activation/:role/:hash', pass.activationAuth, login.activation
router.get  '/restore', login.restore
router.post '/restore', login.restoreHash
router.get  '/restore/:hash', login.change
router.post '/restore/:hash', login.reset
router.get '/test', (req, res, next) -> res.render 'login/test.jade'

module.exports = router
