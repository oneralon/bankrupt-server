module.exports = (req, res, next) ->
  if req.query.render is 'true' and req.connection.remoteAddress is '::1'
    return next()
  if req.headers['user-agent'] is 'android-bankrupt'
    return next()
  return res.status(403).send()