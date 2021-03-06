express       = require 'express'
bodyParser    = require 'body-parser'
cookieParser  = require 'cookie-parser'
session       = require 'express-session'
passport      = require 'passport'
cluster       = require 'cluster'
path          = require 'path'
compression   = require 'compression'
cCPUs         = require('os').cpus().length

redis         = require './modules/redis-session'
logger        = require './middlewares/logger'
mustBeAuth    = require './middlewares/passport'
dbConfig      = require './config/db'

webAPI        = require './routes/web-api'
userAPI       = require './routes/user-api'

base          = __dirname
app           = express()

require './modules/passport'

if cluster.isMaster
  require './cron'
  cluster.on 'online', () ->
    console.log 'Worker started'
  for i in [1..cCPUs]
    cluster.fork process.env

else
  # if process.env.NODE_ENV is 'development'
  app.use logger
  app.use compression()
  app.use cookieParser 'keyboard cat'
  app.use session
    secret: 'keyboard cat'
    name: 'bankrupt.sid'
    store: redis.store
    cookie: {maxAge: 36000000000, path: '/'}
    resave: true
    saveUninitialized: false
  app.use bodyParser.urlencoded
    extended: true
    type: '*/x-www-form-urlencoded'
  app.use passport.initialize()
  app.use passport.session()
  app.set 'views', base + '/views'
  app.set 'view engine', 'jade'

  app.use '/user', userAPI
  app.use '/api', webAPI

  app.use express.static('public')
  app.use express.static('assets')


  # app.use web404

  app.listen process.env.PORT, ->
    console.log "Server listening on port #{process.env.PORT}"
