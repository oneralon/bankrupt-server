session     = require('express-session')
redis       = require('redis')
redisStore  = require('connect-redis')(session)

exports.store = new redisStore
  host: 'localhost'
  port: 6379
  client: redis.createClient()