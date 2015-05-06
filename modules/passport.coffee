passport        = require 'passport'
LocalStrategy   = require('passport-local').Strategy
bcrypt          = require 'bcrypt-nodejs'
mongoose        = require 'mongoose'

require '../models/user'

User            = mongoose.model 'User'

passport.serializeUser (user, done) ->
  console.log 'serializeUser'
  done null, user._id

passport.deserializeUser (id, done) ->
  console.log 'deserializeUser'
  User.findById id, done

passport.use new LocalStrategy (username, password, done) ->
  console.log 'LocalStrategy'
  User.findOne
    username: username
  , (err, user) ->
    return done err if err
    unless user
      return done null, false,
        message: "Incorrect username."

    unless bcrypt.compareSync password, user.password
      return done null, false,
        message: "Incorrect password."

    done null, user
