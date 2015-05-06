passport        = require('passport')
LocalStrategy   = require('passport-local').Strategy
bcrypt          = require('bcrypt-nodejs')

passport.serializeUser (user, done) ->
  role = if user.__options.tableName is 'admins' then 'admin' else 'operator'
  done(null, {id: user.id, role: role})

passport.deserializeUser (user, done) ->
  Users = if user.role is 'admin' then Admin else Operator
  Users.findOne(user.id).then (user) ->
    if user
      user.role = user.role
      done(null, user)
    else done({error: 'User not found'})

ActivationStrategy = new LocalStrategy
  usernameField: 'role'
  passwordField: 'hash'
,
  (role, hash, done) ->
    Users = if role is 'admin' then Admin else Operator
    query = "hashes ? 'activation' AND \
            hashes -> 'activation' = '#{hash}"
    Users.findOne {where: query}
    .catch((err) -> done(err)).then (user) ->
      if user then done null, user
      else done null, false
ActivationStrategy.name = 'activation'
passport.use ActivationStrategy

AdminStrategy = new LocalStrategy
  usernameField: 'email'
  passwordField: 'password'
,
  (email, password, done) ->
    Admin.findOne {where: {email: email, activated: true}}
    .catch((err) -> done(err)).then (admin) ->
      if admin and bcrypt.compareSync(password, admin.password)
        done null, admin
      else done null, false
AdminStrategy.name = 'admin'
passport.use AdminStrategy

OperatorStrategy = new LocalStrategy
  usernameField: 'email'
  passwordField: 'password'
,
  (email, password, done) ->
    Operator.findOne {where: {email: email, disabled: false, activated: true}}
    .catch((err) -> done(err)).then (operator) ->
      if operator and bcrypt.compareSync(password, operator.password)
        done null, operator
      else done null, false
OperatorStrategy.name = 'operator'
passport.use OperatorStrategy

exports.ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    if req.user.sid is req.sessionID then next()
    else
      if req.user.sid isnt ''
        req.flash 'error', req.gettext('Another web-session opened')
      else
        req.flash 'error', req.gettext('Desktop or mobile session opened')
      req.logout()
      res.redirect '/login'
  else res.redirect '/login'

exports.ensureAdmin = (req, res, next) ->
  unless req.user.role
    table = req.user.__options.tableName
    req.user.role = if table is 'admins' then 'admin' else 'operator'
  if req.isAuthenticated() and req.user.role is 'admin' then next()
  else res.sendStatus(403)

exports.ensureOperator = (req, res, next) ->
  if req.isAuthenticated() and req.user.role isnt 'admin' then next()
  else res.sendStatus(403)

exports.activationAuth = (req, res, next) ->
  req.body.role  = req.params.role
  req.body.hash  = req.params.hash
  passport.authenticate('activation',
    failureRedirect: '/login'
    failureFlash: req.gettext('Hash expired or not found')
  )(req, res, next)
