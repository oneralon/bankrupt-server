passport                  = require 'passport'
bcrypt                    = require 'bcrypt-nodejs'
mongoose                  = require 'mongoose'
Promise                   = require 'promise'


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
require '../models/refer'
require '../models/license'

User              = mongoose.model 'User'
Refer             = mongoose.model 'Refer'
License           = mongoose.model 'License'

default_license   = new Promise (resolve, reject) ->
  License.findOne title: 'default', name: 'default', (err, license) ->
    console.log err, license
    if err?
      reject license
    else
      resolve license

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (id, done) ->
  User.findById(id)
  .populate
    path: 'licenses.license_type'
  .exec (err, user) =>
    if user?
      # if user.licenses[0]?.end_date < new Date()
      #   user.licenses.shift()
      #   user.save()
      if user.licenses.length
        user.license = user.licenses[0].license_type
        valid = user.licenses.filter (i) ->
          now = new Date()
          i.start_date <= now and i.end_date >= now
        for license in valid 
          if license.license_type and /prof.*/.test license.license_type.name
            user.license = license.license_type
            break
      # else
      #   console.log 'has not license'
      #   default_license.then (license) ->
      #     user.license = license
      Refer.count sender: user, recipient: $ne: null
      , (err, refers) ->
        user.refers_count = refers
        done err, user
    else done null, null

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
