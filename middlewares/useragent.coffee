module.exports = (req, res, next) ->
  if /android\-bankrupt/.test req.headers['user-agent'] or req.connection.remoteAddress is '127.0.0.1'
    next()
  else res.status(403).send()