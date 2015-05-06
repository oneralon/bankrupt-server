express       = require 'express'
bodyParser    = require 'body-parser'
cookieParser  = require 'cookie-parser'
session       = require 'express-session'
passport      = require 'passport'
redis         = require './modules/redis-session'
logger        = require './middlewares/logger'
dbConfig      = require './config/db'

webAPI        = require './routes/web-api'
login         = require './routes/login'

base          = __dirname
app           = express()

require './modules/passport'

app.use logger

app.use cookieParser 'keyboard cat'
app.use session
  secret: 'keyboard cat'
  name: 'bankrupt.sid'
  store: redis.store
  cookie: {maxAge: 36000000000}
  resave: true
  saveUninitialized: false
app.use bodyParser.urlencoded
  extended: true
  type: '*/x-www-form-urlencoded'
app.use passport.initialize()
app.use passport.session()
app.set 'views', base + '/views'
app.set 'view engine', 'jade'

app.use '/api', webAPI
app.use '/user', login

app.use express.static('public')

# app.use web404

app.listen process.env.PORT, ->
  console.log "Server listening on port #{process.env.PORT}"
