passport                  = require 'passport'
bcrypt                    = require 'bcrypt-nodejs'
mongoose                  = require 'mongoose'


LocalStrategy             = require('passport-local').Strategy

AnonymousStrategy         = require '../helpers/anonymous-strategy'

RegistrationStrategy      = require '../helpers/registration-strategy'
ActivationStrategy        = require '../helpers/activation-strategy'
RegisteredStrategy        = require '../helpers/registered-strategy'

FacebookRegisterStrategy  = require '../helpers/facebook-registration'
FacebookStrategy          = require '../helpers/facebook-strategy'

TwitterRegisterStrategy   = require '../helpers/twitter-registration'
TwitterStrategy           = require '../helpers/twitter-strategy'

VKRegisterStrategy        = require '../helpers/vk-registration'
VKStrategy                = require '../helpers/vk-strategy'

LinkedInRegistration      = require '../helpers/linkedin-registration'
LinkedInStrategy          = require '../helpers/linkedin-strategy'

GoogleRegistration        = require '../helpers/google-registration'
GoogleStrategy            = require '../helpers/google-strategy'

OdnoklassnikiRegistration = require '../helpers/odnoklassniki-registration'
OdnoklassnikiStrategy     = require '../helpers/odnoklassniki-strategy'

require '../models/user'

User              = mongoose.model 'User'

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (id, done) ->
  User.findById(id)
  .populate
    path: 'licenses.license_type'
  .exec done

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


passport.use new LinkedInStrategy () ->
  console.log 'verify func'


passport.use new LinkedInRegistration () ->
  console.log 'verify func'


passport.use new GoogleRegistration () ->
  console.log 'verify func'


passport.use new GoogleStrategy () ->
  console.log 'verify func'


passport.use new OdnoklassnikiRegistration () ->
  console.log 'verify func'


passport.use new OdnoklassnikiStrategy () ->
  console.log 'verify func'
