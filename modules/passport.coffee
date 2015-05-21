passport                  = require 'passport'
bcrypt                    = require 'bcrypt-nodejs'
mongoose                  = require 'mongoose'


LocalStrategy             = require('passport-local').Strategy
AnonymousStrategy         = require '../helpers/anonymous-strategy'#require('passport-anonymous').Strategy
ActivationStrategy        = require '../helpers/activation-strategy'#require('passport-anonymous').Strategy
RegistrationStrategy      = require '../helpers/registration-strategy'#require('passport-anonymous').Strategy
RegisteredStrategy        = require '../helpers/registered-strategy'#require('passport-anonymous').Strategy
FacebookStrategy          = require '../helpers/facebook-strategy'#require('passport-anonymous').Strategy
FacebookRegisterStrategy  = require '../helpers/facebook-registration'#require('passport-anonymous').Strategy
TwitterStrategy           = require '../helpers/twitter-strategy'#require('passport-anonymous').Strategy
TwitterRegisterStrategy   = require '../helpers/twitter-registration'#require('passport-anonymous').Strategy
VKStrategy                = require '../helpers/vk-strategy'#require('passport-anonymous').Strategy
VKRegisterStrategy        = require '../helpers/vk-registration'#require('passport-anonymous').Strategy

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


passport.use new ActivationStrategy () ->
  console.log 'verify func'


passport.use new RegistrationStrategy () ->
  console.log 'verify func'


passport.use new RegisteredStrategy () ->
  console.log 'verify func'


passport.use new FacebookRegisterStrategy () ->
  console.log 'verify func'


passport.use new FacebookStrategy () ->
  console.log 'verify func'

passport.use new VKStrategy () ->
  console.log 'verify func'

passport.use new VKRegisterStrategy () ->
  console.log 'verify func'

passport.use new TwitterRegisterStrategy () ->
  console.log 'verify func'


passport.use new TwitterStrategy () ->
  console.log 'verify func'
