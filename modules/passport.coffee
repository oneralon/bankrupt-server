passport          = require 'passport'
bcrypt            = require 'bcrypt-nodejs'
mongoose          = require 'mongoose'


LocalStrategy     = require('passport-local').Strategy
AnonymousStrategy = require '../helpers/anonymous-strategy'#require('passport-anonymous').Strategy

require '../models/user'

User              = mongoose.model 'User'

passport.serializeUser (user, done) ->
  console.log 'serializeUser'
  done null, user._id

passport.deserializeUser (id, done) ->
  console.log 'deserializeUser'
  User.findById id, done

passport.use new AnonymousStrategy () ->
  console.log 'verify func'
